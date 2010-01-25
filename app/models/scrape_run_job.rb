require 'uri'
require 'fileutils'
require 'rest_client'

class ScrapeRunJob

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
      `pdftotext -layout #{file} #{text_file}`
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

    def scrape_run_attributes uri, response, header, file
      {
        'scrape_run[response_code]' => response.code,
        'scrape_run[last_modified]' => header[:last_modified],
        'scrape_run[etag]' => header[:etag],
        'scrape_run[content_type]' => header[:content_type],
        'scrape_run[content_length]' => header[:content_length],
        'scrape_run[response_header]' => response.raw_headers.inspect,
        'scrape_run[uri]' => uri,
        'scrape_run[file_path]' => file
      }
    end

    def http_callback response, uri
      headers = response.headers
      file = uri_file_name(uri)

      write_file "#{file}.response.yml", {:uri => uri}.merge(headers).to_yaml.sort
      write_file file, response.to_s
      pdftotext file if headers[:content_type] == 'application/pdf'

      update_scrape_run scrape_run_attributes(uri, response, headers, file)
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
