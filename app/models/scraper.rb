require 'open-uri'

class Scraper < ActiveRecord::Base
  
  class << self

    def scrapers_by_namespace
      Dir.glob(RAILS_ROOT + '/lib/scrapers/*').collect do |directory|
        namespace = directory.split('/').last
        
        scrapers = Dir.glob("#{directory}/*.rb").collect do |file|
        scraper = find_by_scraper_file(file)
          unless scraper
            name = File.basename(file, '.rb').humanize
            scraper = Scraper.new(:scraper_file => file, :namespace => namespace, :name => name)
            scraper.save!
          end
          scraper
        end
        [namespace, scrapers]
      end
    end
  end
  
  def code
    open(scraper_file).read
  end
end
