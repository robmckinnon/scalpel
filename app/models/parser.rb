require 'namespaced_code_file'

class Parser < ActiveRecord::Base
  
  has_many :parse_runs
  
  belongs_to :scraper

  include Acts::NamespacedCodeFile

  class << self
    def code_suffix
      '_parse'
    end
  end

  def run
    scrape_result = scraper.last_scrape_result
    parser = code_instance
    
    parser.perform scrape_result
  end

end
