require 'namespaced_code_file'

class Parser < ActiveRecord::Base
  
  has_many :parse_runs
  
  belongs_to :scraper

  before_save :populate_scraper
  
  include Acts::NamespacedCodeFile

  class << self
    def code_suffix
      '_parse'
    end
  end

  def run
    scrape_result = scraper ? scraper.last_scrape_result : nil
    parser = code_instance
    parser.perform scrape_result
  end
  
  def populate_scraper
    unless scraper_id
      scraper_file = parser_file.gsub('parse','scrape')
      if File.exist?(scraper_file)
        scraper = Scraper.find_by_scraper_file(scraper_file)
        if scraper
          self.scraper_id = scraper.id
        end
      end
    end
  end

end
