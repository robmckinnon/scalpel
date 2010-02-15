require 'grit'

class WebResource < ActiveRecord::Base

  validates_uniqueness_of :uri

  has_many :scrape_runs

  class << self
    def scrape uri
      web_resource = find_or_create_by_uri uri
      web_resource.do_scrape # synchronous call
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
  def do_scrape
    scrape_run = scrape_runs.create
    scrape_run.do_run
    reload # reloads attributes from database
    nil
  end
  
  def contents
    Dir.chdir ScrapeRunJob.data_git_dir
    repo = Grit::Repo.new('.')
    commit = repo.commit git_commit_sha
    blob = commit ? (commit.tree / git_path) : nil
    blob ? blob.data : nil
  end
end
