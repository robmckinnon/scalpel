class ScrapeRun < ActiveRecord::Base
  
  belongs_to :scrape_job
  validates_presence_of :scrape_job_id

  after_save :update_etag_and_last_modified
    
  def start_run
    if response_code.blank? && RAILS_ENV != 'test'
      Delayed::Job.enqueue ScrapeRunJob.new(scrape_job.uri, scrape_job.id, self.id, scrape_job.etag, scrape_job.last_modified)
    end
  end
  
  def update_etag_and_last_modified
    if !etag.blank? || !last_modified.blank?
      scrape_job.etag = etag
      scrape_job.last_modified = last_modified
      scrape_job.save
    end
  end

end
