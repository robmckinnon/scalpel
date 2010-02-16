class ScrapeResult < ActiveRecord::Base

  belongs_to :scraper
  has_many :scraped_resources

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
end
