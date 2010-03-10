require 'hpricot'

class WebResource < ActiveRecord::Base

  validates_uniqueness_of :uri
  validates_uniqueness_of :git_path, :allow_nil => true

  has_many :scraped_resources
  has_many :scrape_runs

  class << self
    def scrape uri, result, &block
      web_resource = find_or_create_by_uri(uri)
      if web_resource.scrape_runs.empty?
        web_resource.scrape_runs = []
        web_resource.save!
      end
      web_resource.do_scrape &block # synchronous call
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
  def do_scrape &block
    scrape_run = scrape_runs.create
    scrape_run.do_run &block
    reload # reloads attributes from database
    nil
  end
  
  # def last_commit
    # repo = GitRepo.git_repo
    # repo.commit git_commit_sha
  # end

  def plain_pdf_contents
    if git_path[/\.pdf\.txt$/]
      if file_path && File.exist?(file_path)
        if (file_path[/pdf$/] && file_path.sub('.pdf','.txt'))
          IO.read(file_path.sub('.pdf','.txt'))
        else
          IO.read(file_path)
        end
      elsif data = GitRepo.data(git_commit_sha, git_path.sub('.pdf.txt','.txt') )
        data
      end
    else
      nil
    end
  end
  
  def contents
    if file_path && File.exist?(file_path)
      IO.read(file_path)
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
