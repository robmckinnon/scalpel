class WebResource < ActiveRecord::Base

  has_many :scrape_runs

  class << self
  end
  
  # start scrape - asynchronous
  def start_scrape
    scrape_run = scrape_runs.create
    scrape_run.start_run
    nil
  end

end
