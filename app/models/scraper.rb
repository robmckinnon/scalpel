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

  def last_scrape_result
    scrape_results.last
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

  def commit_message repo, scraper
    changes = []
    repo.each_status_type do |type, files|
      changes << "#{type}: #{files.size}" if (files.size > 0)
    end
    message = "committing run of #{scraper.class.name} [#{Time.now}] (#{changes.join(", ")})"
  end
  
  def add_untracked_and_changed_files repo, result
    resources = result.resources_to_add
    files = result.files_to_add

    while files.size > 0
      puts "adding #{files.size} files to git"
      repo.add_to_git(files)
      files = result.files_to_add
      puts "***\n #{files.size} files didn't get added: #{files.inspect}" unless files.empty?
    end

    resources
  end

  def set_commit_sha_on_resources commit_sha, resources
    if commit_sha
      puts "commit_sha: #{commit_sha}"
      resources.each do |resource|
        resource.git_commit_sha = commit_sha
        resource.save!
        if resource.is_a?(ScrapedResource)
          resource.web_resource.git_commit_sha = commit_sha
          resource.save!
        end
      end
    end
  end

  def run do_scrape=true
    scraper = code_instance

    if do_scrape
      result = scrape_results.create
      scraper.perform result
    else
      result = scrape_results.last
    end
    
    resources = []
    commit_sha = nil
    GitRepo.while_locked do |repo|
      resources = add_untracked_and_changed_files repo, result
      message = commit_message(repo, scraper)
      commit_sha = repo.commit_to_git(message)
    end
    
    set_commit_sha_on_resources commit_sha, resources

    result.end_time = Time.now
    result.save!

    if parser
      puts 'running parser...'
      parser.run
    end
    commit_sha
  end

end
