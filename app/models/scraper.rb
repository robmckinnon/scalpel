require 'open-uri'

class Scraper < ActiveRecord::Base
  
  has_many :scrape_results

  class << self

    def run path
      scraper = find_by_scraper_path path
      scraper.run_scraper
    end
    
    def find_by_scraper_path path
      find_by_scraper_file("#{scrapers_dir}#{path}")
    end

    def scrapers_dir
      "#{RAILS_ROOT}/lib/scrapers"
    end

    def scrapers_by_namespace
      Dir.glob("#{scrapers_dir}/*").collect do |directory|
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
    
    def schedule_code
      code = ['set :output, "#{RAILS_ROOT}/log/whenever_cron.log"' + "\n" ]
      find_each {|scraper| code << scraper.schedule_code }
      code.join("\n")
    end
    
    def update_crontab
      File.open("#{RAILS_ROOT}/config/schedule.rb", 'w') do |file|
        file.write schedule_code
      end
      Dir.chdir RAILS_ROOT
      `bundle exec whenever --set environment=#{RAILS_ENV} --update-crontab`
      `bundle exec whenever --set environment=#{RAILS_ENV}`
    end
  end

  def scraper_path
    scraper_file.sub("#{Scraper.scrapers_dir}",'')
  end

  def schedule_code
    if schedule_every.blank?
      ''
    else
      code = ["every #{schedule_every} do"]
      code << %Q[  runner "Scraper.run('#{scraper_path}')"]
      code << "end\n"
      code.join("\n")
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
