class ScrapeRun < ActiveRecord::Base
  
  belongs_to :scrape_job
  validates_presence_of :scrape_job_id

  after_save :start_run
    
  def start_run
    if response_code.blank? && RAILS_ENV != 'test'
      Delayed::Job.enqueue ScrapeRunJob.new(scrape_job.uri, scrape_job.id, self.id)
    end
  end

end
