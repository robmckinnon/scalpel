class ScrapeRun < ActiveRecord::Base
  
  belongs_to :web_resource
  validates_presence_of :web_resource_id

  after_save :update_etag_and_last_modified

  # do synchronous scrape run
  def do_run
    if response_code.blank? && RAILS_ENV != 'test'
      job = ScrapeRunJob.new(web_resource.uri, web_resource.id, self.id, web_resource.etag, web_resource.last_modified)
      job.perform # updates scrape run via restful api
    end
  end

  # start asynchronous scrape run
  def start_run
    if response_code.blank? && RAILS_ENV != 'test'
      Delayed::Job.enqueue ScrapeRunJob.new(self.id, web_resource)
    end
  end
  
  def update_etag_and_last_modified_and_git_commit_sha
    if !etag.blank? || !last_modified.blank? || !git_commit_sha.blank?
      web_resource.etag = etag
      web_resource.last_modified = last_modified
      web_resource.git_commit_sha = git_commit_sha if git_commit_sha

      web_resource.file_path = file_path if file_path
      web_resource.git_path = git_path if git_path
      web_resource.git_commit_sha = git_commit_sha if git_commit_sha
      web_resource.save
    end
  end

end
