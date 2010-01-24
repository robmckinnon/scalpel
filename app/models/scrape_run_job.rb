require 'em-http' # used for http requests via deferred callbacks 
require 'uri'
require 'fileutils'
require 'rest_client'

class ScrapeRunJob
  
  def initialize uri, scrape_job_id, scrape_run_id
    @uri, @scrape_job_id, @scrape_run_id = uri, scrape_job_id, scrape_run_id
  end

  def perform
    EventMachine.run do
      http = EventMachine::HttpRequest.new(@uri, :head => {}).get :timeout => 10
      http.callback do
        http_callback http, @uri
        EventMachine.stop
      end
      http.errback do
        http_errback http, @uri
        EventMachine.stop
      end
    end
  end

  private
  
    def file_name name
      File.join(RAILS_ROOT, 'data', name)
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

    def http_callback http, uri
      file = uri_file_name(uri)
      write_file file, http.response
      header = http.response_header
      
      data = {
        'scrape_run[response_code]' => header.status,
        'scrape_run[last_modified]' => header['LAST_MODIFIED'],
        'scrape_run[etag]' => header['ETAG'],
        'scrape_run[content_type]' => header['CONTENT_TYPE'],
        'scrape_run[content_length]' => header['CONTENT_LENGTH'],
        'scrape_run[response_header]' => header.inspect,
        'scrape_run[uri]' => uri,
        'scrape_run[file_path]' => file
      }
      write_file file_name('data.yml'), data.to_yaml
      
      resource_uri = "http://localhost:3000/scrape_jobs/#{@scrape_job_id}/scrape_runs/#{@scrape_run_id}"
      write_file file_name('resource_uri'), resource_uri
      resource = RestClient::Resource.new resource_uri
      resource.put data
    end

    def http_errback http, uri
      puts "#{uri}\n" + http.errors     
      EventMachine.stop
    end
end
