require 'rest_client'
require 'mechanize'

class ScrapeRunJob
  
  def initialize scrape_run_id, web_resource, asynchronus=false, &block
    @uri = web_resource.uri
    @web_resource_id = web_resource.id
    @scrape_run_id = scrape_run_id
    @etag = web_resource.etag
    @last_modified = web_resource.last_modified
    @before_save_block = block ? block : nil
    @prev_git_commit_sha = web_resource.git_commit_sha
    @prev_git_path = web_resource.git_path
    @asynchronus = asynchronus
  end

  def perform options={}
    options.merge!({'If-None-Match' => @etag}) if @etag
    options.merge!({'If-Modified-Since' => @last_modified}) if @last_modified

    if proc = options[:scrape_proc]
      proc.call(@uri, options, self)
    else
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
  end

  private
  
    def update_scrape_run data
      if @asynchronus
        begin
          resource_uri = "http://localhost:3000/web_resources/#{@web_resource_id}/scrape_runs/#{@scrape_run_id}"
          resource = RestClient::Resource.new resource_uri
          resource.put data
        rescue Exception => e
          puts e.to_s
        end
      else
        scrape_run = ScrapeRun.find(@scrape_run_id)
        scrape_run.update_attributes(data)
      end
    end

    def scrape_run_attributes uri, response_code, raw_response_header, header, file, relative_git_path, commit_sha
      if @asynchronus
        {
          'scrape_run[response_code]' => response_code,
          'scrape_run[last_modified]' => header[:last_modified],
          'scrape_run[etag]' => header[:etag],
          'scrape_run[content_type]' => header[:content_type],
          'scrape_run[content_length]' => header[:content_length],
          'scrape_run[response_header]' => raw_response_header.inspect,
          'scrape_run[uri]' => uri,
          'scrape_run[file_path]' => file,
          'scrape_run[git_path]' => relative_git_path,
          'scrape_run[git_commit_sha]' => commit_sha
        }
      else
        {
          :response_code => response_code,
          :last_modified => header[:last_modified],
          :etag => header[:etag],
          :content_type => header[:content_type],
          :content_length => header[:content_length],
          :response_header => raw_response_header.inspect,
          :uri => uri,
          :file_path => file,
          :git_path => relative_git_path,
          :git_commit_sha => commit_sha
        }
      end
    end

    def pdf_to_text pdf_file, response_body
      GitRepo.write_file pdf_file, response_body
      text_file = GitRepo.convert_pdf_file pdf_file      
    end

    def is_pdf? headers
      headers[:content_type][/^application\/pdf/] ? true : false
    end

    def headers_text(uri, code, response_header)
      hash = response_header.merge({:uri => uri,
        :response_code => code
      })
      # if response.respond_to?(:net_http_res)
        # hash = hash.merge({:response_message => response.net_http_res.message})
      # end
      array = hash.to_a.sort{|a,b| a[0].to_s <=> b[0].to_s}
      ordered_map = YAML::Omap.new(array)
      ordered_map.to_yaml
    end

    def http_callback response, uri, &block
      body_file = GitRepo.uri_file_name(uri, response.headers[:content_type], response.headers[:content_disposition])
      puts body_file
      if is_pdf?(response.headers) || uri[/pdf$/] || body_file[/pdf$/]
        response_file = pdf_to_text(body_file, response.to_s)
        response_text = IO.read(response_file)
      else
        response_file = body_file
        response_text = response.to_s
      end

      yield response_text if block # process text before saving
      
      handle_response_text response.code, response.raw_headers, response.headers, response_text, response_file, body_file, uri
    end
    
    def diff str1, str2
      system "diff #{file_for str1} #{file_for str2}"
    end
    
    def file_for text
      exp = Tempfile.new("bk", "/tmp").open
      exp.write(text)
      exp.close
      exp.path
    end

  public

    def handle_response_text response_code, raw_response_header, response_header, response_text, response_file, body_file, uri
      commit_sha = nil
      git_path = GitRepo.relative_git_path(response_file)

      unless no_need_to_update?(response_text)
        if @prev_git_path
          puts "==="
          puts "needs update"
          puts "@prev_git_commit_sha: #{@prev_git_commit_sha}"
          puts "@prev_git_path: #{@prev_git_path}"
          puts "diff: #{diff(response_text, last_contents)}"
        end
        headers_file = "#{body_file}.response.yml"
        GitRepo.write_file(headers_file, headers_text(uri, response_code, response_header))
        GitRepo.write_file(response_file, response_text)
      end

      update_scrape_run scrape_run_attributes(uri, response_code, raw_response_header, response_header, body_file, git_path, commit_sha)
    end

  private

    def last_contents
      if @prev_git_commit_sha.blank?
        nil
      else
        GitRepo.data_from_repo @prev_git_commit_sha, @prev_git_path
      end
    end

    def no_need_to_update?(response_text)
      response_text.to_s.strip == last_contents.to_s.strip
    end
    
    def http_errback e, uri
      if e.is_a?(RestClient::Exception)
        attribute = @asynchronus ? 'scrape_run[response_code]' : :response_code
        data = { attribute => e.http_code }
        update_scrape_run data
      else
        puts "#{uri}\n" + e.to_s
        puts e.backtrace.join("\n")
      end
   end
end
