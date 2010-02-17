require 'rest_client'

class ScrapeRunJob
  
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
        'scrape_run[git_path]' => GitRepo.relative_git_path(git_path),
        'scrape_run[git_commit_sha]' => commit_sha
      }
    end

    def http_callback response, uri, &block
      headers = response.headers
      body_file = GitRepo.uri_file_name(uri, headers[:content_type])
      headers_file = "#{body_file}.response.yml"

      headers_text = {:uri => uri}.merge(headers).to_yaml.sort
      response_body = response.to_s
            
      yield response_body if block # process text before saving

      GitRepo.write_file headers_file, headers_text
      GitRepo.write_file body_file, response_body

      if headers[:content_type] == 'application/pdf'
        git_body_file = pdftotext(body_file)
        response_body = IO.read(git_body_file)
      else
        git_body_file = body_file
      end

      if no_need_to_update?(response_body)
        commit_sha = nil
      else
        commit_sha = GitRepo.commit_to_git headers[:date], headers_file, headers_text, git_body_file, response_body
      end
      update_scrape_run scrape_run_attributes(uri, response, headers, body_file, git_body_file, commit_sha)
    end
    
    def last_contents
      if @prev_git_commit_sha.blank?
        nil
      else
        commit = GitRepo.rescue_if_git_timeout do |git_repo|
          git_repo.commit @prev_git_commit_sha
        end

        blob = commit ? (commit.tree / @prev_git_path) : nil
        blob ? blob.data : nil
      end
    end

    def no_need_to_update?(response_body)
      response_body == last_contents 
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
