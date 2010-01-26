class ScrapeRun < ActiveRecord::Base
  
  belongs_to :scraper
  validates_presence_of :scraper_id

  after_save :update_etag_and_last_modified
    
  def start_run
    if response_code.blank? && RAILS_ENV != 'test'
      Delayed::Job.enqueue ScrapeRunJob.new(scraper.uri, scraper.id, self.id, scraper.etag, scraper.last_modified)
    end
  end
  
  def update_etag_and_last_modified
    if !etag.blank? || !last_modified.blank?
      scraper.etag = etag
      scraper.last_modified = last_modified
      scraper.save
    end
  end

end
