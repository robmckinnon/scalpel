require 'uri'
require 'fileutils'
require 'rest_client'
require 'grit'

class ScrapeRunJob

  include Grit

  class << self
    def data_git_dir= dir
      @data_git_dir = dir
    end
    def data_git_dir
      @data_git_dir
    end
  end
  
  def initialize uri, scrape_job_id, scrape_run_id, etag, last_modified
    @uri, @scrape_job_id, @scrape_run_id, @etag, @last_modified = uri, scrape_job_id, scrape_run_id, etag, last_modified
  end

  def perform
    options = {}
    options.merge!({'If-None-Match' => @etag}) if @etag
    options.merge!({'If-Modified-Since' => @last_modified}) if @last_modified
      
    begin
      response = RestClient.get @uri, options 
      http_callback response, @uri
    rescue Exception => e
      http_errback e, @uri
    end
  end

  private
  
    def file_name name
      File.join(ScrapeRunJob.data_git_dir, name)
    end

    def uri_file_name uri
      file = file_name(uri.chomp('/').sub(/^https?:\/\//,'').split(/\/|\?/))
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
        resource_uri = "http://localhost:3000/scrape_jobs/#{@scrape_job_id}/scrape_runs/#{@scrape_run_id}"      
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

    def http_callback response, uri
      headers = response.headers
      body_file = uri_file_name(uri)
      headers_file = "#{body_file}.response.yml"

      headers_text = {:uri => uri}.merge(headers).to_yaml.sort
      response_body = response.to_s

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
      file.sub(ScrapeRunJob.data_git_dir,'').sub(/^\//,'')
    end
    
    def commit_to_git date, headers_file, headers_text, git_body_file, response_body
      relative_body_path = relative_git_path(git_body_file)
      relative_headers_path = relative_git_path(headers_file)
      
      Dir.chdir ScrapeRunJob.data_git_dir
      repo = Repo.new('.')
      repo.add(relative_body_path)
      repo.add(relative_headers_path)
      message = "committing: #{relative_body_path} [#{date}]"
      result = repo.commit_index(message)

      puts result

      commit = if result[/nothing added to commit/] || result[/nothing to commit/]
            nil
          else
            repo.commits.select {|c| c.message == message}.first
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

    def http_errback e, uri
      if e.is_a?(RestClient::Exception)
        data = { 'scrape_run[response_code]' => e.http_code }
        update_scrape_run data
      else
        puts "#{uri}\n" + e.to_s     
      end
    end
end
