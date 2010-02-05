class WebResource < ActiveRecord::Base

  has_many :scrape_runs

  # start scrape - asynchronous
  def start_scrape
    scrape_run = scrape_runs.create
    scrape_run.start_run
    nil
  end

end
