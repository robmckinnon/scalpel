require 'open-uri'
require 'namespaced_code_file'

class Scraper < ActiveRecord::Base
  
  has_many :scrape_results
  has_one :parser

  include Acts::NamespacedCodeFile

  class << self
    
    def code_suffix
      '_scrape'
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
    scraper_file.sub("#{Scraper.code_dir}",'')
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

  def run
    commit_at_end = true # always commit at end
    result = scrape_results.create
    result.commit_result = !commit_at_end

    scraper = code_instance
    scraper.perform result

    if commit_at_end
      message = "committing run of #{scraper.class.name} [#{Time.now}]"
      commit_sha = GitRepo.commit_to_git(message)
    end

    result.end_time = Time.now
    result.save
  end

end
