require 'uri'
require 'fileutils'
require 'rest_client'
require 'grit'

class ScrapeRunJob

  class << self
    def data_git_dir= dir
      FileUtils.mkdir_p dir unless File.exist? dir
      @data_git_dir = dir
    end
    def data_git_dir
      @data_git_dir
    end
    
    def git_dir= dir
      @git_dir = dir
    end
    def git_dir
      @git_dir
    end
    
    def git_repo force=false
      if !@repo || force
        Dir.chdir git_dir
        @repo = Grit::Repo.new('.')
      end
      @repo
    end
  end
  
  def initialize scrape_run_id, web_resource, &block
    @uri = web_resource.uri
    @web_resource_id = web_resource.id
    @scrape_run_id = scrape_run_id
    @etag = web_resource.etag
    @last_modified = web_resource.last_modified
    @before_save_block = block ? block : nil
    @prev_git_commit_sha = web_resource.git_commit_sha
    @prev_git_path = web_resource.git_path
  end

  def perform
    options = {}
    options.merge!({'If-None-Match' => @etag}) if @etag
    options.merge!({'If-Modified-Since' => @last_modified}) if @last_modified

    begin
      response = RestClient.get @uri, options
      if @before_save_block
        http_callback response, @uri, &@before_save_block
      else
        http_callback response, @uri
      end
    rescue Exception => e
      http_errback e, @uri
    end
  end

  private
  
    def repo force=false
      ScrapeRunJob.git_repo force
    end

    def file_name uri
      parts = uri.chomp('/').sub(/^https?:\/\//,'').split(/\/|\?/).collect {|p| p[/^&?(.+)&?$/,1].gsub('&','__')}
      File.join(ScrapeRunJob.data_git_dir, parts)
    end

    def uri_file_name uri, content_type
      uri_path = URI.parse(uri)
      file_type = content_type.split('/').last.split(';').first

      if uri_path == '/'
        uri = "#{uri}index.#{file_type}"
      end
      file = file_name(uri)
      
      if File.extname(file) == ''
        file = "#{file}.#{file_type}"
      end

      path = File.dirname file
      FileUtils.mkdir_p(path) unless File.exist?(path)
      file
    end
    
    def write_file name, contents
      File.open(name, 'w') do |f|
        f.write contents
      end      
    end

    def pdftotext file
      text_file = "#{file}.txt"
      `pdftotext -enc UTF-8 -layout #{file} #{text_file}`
      text_file
    end

    def update_scrape_run data
      begin
        resource_uri = "http://localhost:3000/web_resources/#{@web_resource_id}/scrape_runs/#{@scrape_run_id}"      
        resource = RestClient::Resource.new resource_uri
        resource.put data
      rescue Exception => e
        puts e.to_s
      end
    end

    def scrape_run_attributes uri, response, header, file, git_path, commit_sha
      {
        'scrape_run[response_code]' => response.code,
        'scrape_run[last_modified]' => header[:last_modified],
        'scrape_run[etag]' => header[:etag],
        'scrape_run[content_type]' => header[:content_type],
        'scrape_run[content_length]' => header[:content_length],
        'scrape_run[response_header]' => response.raw_headers.inspect,
        'scrape_run[uri]' => uri,
        'scrape_run[file_path]' => file,
        'scrape_run[git_path]' => relative_git_path(git_path),
        'scrape_run[git_commit_sha]' => commit_sha
      }
    end

    def http_callback response, uri, &block
      headers = response.headers
      body_file = uri_file_name(uri, headers[:content_type])
      headers_file = "#{body_file}.response.yml"

      headers_text = {:uri => uri}.merge(headers).to_yaml.sort
      response_body = response.to_s
            
      yield response_body if block # process text before saving

      write_file headers_file, headers_text
      write_file body_file, response_body

      if headers[:content_type] == 'application/pdf'
        git_body_file = pdftotext(body_file)
        response_body = IO.read(git_body_file)
      else
        git_body_file = body_file
      end

      commit_sha = commit_to_git headers[:date], headers_file, headers_text, git_body_file, response_body
      update_scrape_run scrape_run_attributes(uri, response, headers, body_file, git_body_file, commit_sha)
    end

    def relative_git_path file
      file.sub(ScrapeRunJob.git_dir,'').sub(/^\//,'')
    end

    def rescue_if_git_timeout &block
      begin
        yield repo
      rescue Grit::Git::GitTimeout => e
        puts e.class.name
        puts e.to_s
        puts e.backtrace.select{|x| x[/app\/models/]}.join("\n")
        sleep 5
        repo(force=true)
        rescue_if_git_timeout &block
      end      
    end
    
    def last_contents
      if @prev_git_commit_sha.blank?
        nil
      else
        commit = rescue_if_git_timeout do |git_repo|
          git_repo.commit @prev_git_commit_sha
        end

        blob = commit ? (commit.tree / @prev_git_path) : nil
        blob ? blob.data : nil
      end
    end

    def no_need_to_update?(response_body)
      response_body == last_contents 
    end
    
    def commit_to_git date, headers_file, headers_text, git_body_file, response_body
      if no_need_to_update?(response_body)
        nil
      else
        relative_body_path = relative_git_path(git_body_file)
        relative_headers_path = relative_git_path(headers_file)
        
        repo.add(relative_body_path)
        repo.add(relative_headers_path)
        message = "committing: #{relative_body_path} [#{date}]"
        puts message
        result = rescue_if_git_timeout do |git_repo|
          git_repo.commit_index(message)
        end
  
        puts '---'
        puts result
        puts '==='
  
        commit = if result[/nothing added to commit/] || result[/nothing to commit/]
              nil
            else
              repo.commits.detect {|c| c.message == message}
            end
  
        commit ? commit.id : nil
        # index = repo.index
        # index.read_tree('master')
  # 
        # repo.add(relative_body_path)
        # repo.add(relative_headers_path)
        # index.add(relative_body_path, response_body)
        # index.add(relative_headers_path, headers_text)
  # 
        # message = "committing: #{relative_body_path}"
        # commit_sha = index.commit(message, parents=[repo.commits.first], actor=nil, repo.tree('master'), 'master')
        # commit_sha
      end
    end

    def http_errback e, uri
      if e.is_a?(RestClient::Exception)
        data = { 'scrape_run[response_code]' => e.http_code }
        update_scrape_run data
      else
        puts "#{uri}\n" + e.to_s
        puts e.backtrace.join("\n")
      end
    end
end
