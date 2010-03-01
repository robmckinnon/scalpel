class ScrapeRun < ActiveRecord::Base
  
  belongs_to :web_resource
  validates_presence_of :web_resource_id

  after_save :update_etag_and_last_modified_and_git_commit_sha

  # do synchronous scrape run
  def do_run &block
    if response_code.blank? && RAILS_ENV != 'test'
      job = ScrapeRunJob.new(self.id, web_resource, asynchronus=false, &block)
      job.perform # updates scrape run via restful api
    end
  end

  # start asynchronous scrape run
  def start_run
    if response_code.blank? && RAILS_ENV != 'test'
      Delayed::Job.enqueue ScrapeRunJob.new(self.id, web_resource, false, asynchronus=true)
    end
  end
  
  def update_etag_and_last_modified_and_git_commit_sha
    if !etag.blank? || !last_modified.blank? || !git_commit_sha.blank? || !git_path.blank?
      web_resource.etag = etag
      web_resource.last_modified = last_modified
      web_resource.git_commit_sha = git_commit_sha if git_commit_sha

      web_resource.file_path = file_path if file_path
      web_resource.git_path = git_path if git_path
      web_resource.git_commit_sha = git_commit_sha if git_commit_sha
      web_resource.save
    end
  end

  def headers_file
    "#{file_path}.response.yml"
  end
end
