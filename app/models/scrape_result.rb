class ScrapeResult < ActiveRecord::Base

  belongs_to :scraper
  has_many :scraped_resources

  before_create :set_start_time

  def add web_resource
    unless has_resource?(web_resource)
      scraped_resources.create(:web_resource_id => web_resource.id,
        :git_path => web_resource.git_path,
        :git_commit_sha => web_resource.git_commit_sha)
    end
  end
  
  def has_resource? web_resource
    if scraped_resources.find(:first, :conditions => "web_resource_id = '#{web_resource.id}'")
      true
    else
      false
    end
  end
  
  def untracked_resources
    resource_by_path = scraped_resources.group_by(&:git_path)
    untracked_paths = GitRepo.select_untracked(resource_by_path.keys)
    untracked_paths.collect { |path| resource_by_path[path] }.flatten
  end

  private
    def set_start_time
      self.start_time = Time.now
    end
end
