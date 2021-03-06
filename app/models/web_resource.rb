require 'hpricot'

class WebResource < ActiveRecord::Base

  validates_uniqueness_of :uri
  validates_uniqueness_of :git_path, :allow_nil => true

  has_many :scraped_resources
  has_many :scrape_runs

  class << self
    def scrape_and_add uri, result, options={}
      resource = WebResource.scrape(uri, result, options)
      result.add_resource(resource)
      resource
    end

    def scrape uri, result, options={}, &block
      web_resource = find_or_create_by_uri(uri)
      if web_resource.scrape_runs.empty?
        web_resource.scrape_runs = []
        web_resource.save!
      end
      web_resource.do_scrape(options, &block) # synchronous call
      result.add_working_file(web_resource) if result
      web_resource
    end
  end
  
  def headers_git_path
    GitRepo.relative_git_path(headers_file)
  end

  def headers_file
    "#{file_path}.response.yml"
  end

  # start scrape - asynchronous
  def start_scrape
    scrape_run = scrape_runs.create
    scrape_run.start_run
    nil
  end
  
  # do scrape - synchronous
  def do_scrape options={}, &block
    scrape_run = scrape_runs.create
    scrape_run.do_run(options, &block)
    reload # reloads attributes from database
    nil
  end
  
  # def last_commit
    # repo = GitRepo.git_repo
    # repo.commit git_commit_sha
  # end

  def xml_pdf_contents
    if git_path[/\.pdf\.txt$/]
      if file_path && File.exist?(file_path)
        read_file '.xml'
      elsif data = GitRepo.data(git_commit_sha, git_path.sub(/\.pdf\.txt$/,'.xml') )
        data
      end
    else
      nil
    end
  end

  def plain_pdf_contents
    if git_path[/\.pdf\.txt$/]
      if file_path && File.exist?(file_path)
        read_file '.txt'
      elsif data = GitRepo.data(git_commit_sha, git_path.sub(/\.pdf\.txt$/,'.txt') )
        data
      end
    else
      nil
    end
  end

  def read_file ext
    if file_path[/pdf$/] && (file_name = file_path.sub(/\.pdf$/,ext))
      content = IO.read(file_name)
      charset = CMess::GuessEncoding::Automatic.guess(content) 
      Iconv.conv('utf-8', charset, content)
    else
      content = IO.read(file_path)
      charset = CMess::GuessEncoding::Automatic.guess(content)
      content = Iconv.conv('utf-8', charset, content) unless charset == 'UNKNOWN'
      content
    end
  end

  def contents
    if file_path && File.exist?(file_path)
      read_file '.pdf.txt'
    elsif data = GitRepo.data(git_commit_sha, git_path)
      data
    else
      nil
    end
  end

  def hpricot_doc
    if contents
      @doc ||= Hpricot contents
    else
      nil
    end
  end

  def links
    contents ? (hpricot_doc/'a') : []
  end
end
