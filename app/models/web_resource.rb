require 'hpricot'

class WebResource < ActiveRecord::Base

  validates_uniqueness_of :uri
  validates_uniqueness_of :git_path, :allow_nil => true

  has_many :scraped_resources
  has_many :scrape_runs

  class << self
    def scrape uri, &block
      web_resource = find_or_create_by_uri(uri)
      if web_resource.scrape_runs.empty?
        web_resource.scrape_runs = []
        web_resource.save!
      end
      web_resource.do_scrape &block # synchronous call
      web_resource
    end
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
  
  def last_commit
    repo = GitRepo.git_repo
    repo.commit git_commit_sha
  end

  def contents
    commit = last_commit
    blob = commit ? (commit.tree / git_path) : nil
    blob ? blob.data : nil
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
