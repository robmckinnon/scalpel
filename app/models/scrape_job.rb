class ScrapeJob < ActiveRecord::Base
  
  has_many :scrape_runs

end
