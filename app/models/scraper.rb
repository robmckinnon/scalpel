require 'open-uri'

class Scraper < ActiveRecord::Base
  
  has_many :scrape_results

  class << self

    def scrapers_by_namespace
      Dir.glob(RAILS_ROOT + '/lib/scrapers/*').collect do |directory|
        namespace = directory.split('/').last
        
        scrapers = Dir.glob("#{directory}/*_scrape.rb").collect do |file|
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

  def run_scraper
    commit_at_end = true # always commit at end
    result = scrape_results.create
    result.commit_result = !commit_at_end

    scraper = scraper_instance
    scraper.perform result

    if commit_at_end
      message = "committing run of #{scraper.class.name} [#{Time.now}]"
      commit_sha = GitRepo.commit_to_git(message)
    end

    result.end_time = Time.now
    result.save
  end

  def first_run?
    scrape_results.empty?
  end
  
  private
    
    def scraper_instance
      require scraper_file
      scraper_module = namespace.camelize
      scraper_class = File.basename(scraper_file.chomp('.rb')).camelize
      scraper_type = "#{scraper_module}::#{scraper_class}".constantize
      scraper_type.new
    end

end
