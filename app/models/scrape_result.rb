class ScrapeResult < ActiveRecord::Base

  belongs_to :scraper
  has_many :scraped_resources

  before_create :set_start_time, :initialize_working_files
  
  def working_files
    @working_files ||= {}
    @working_files.keys
  end

  def add_working_file web_resource
    @working_files[web_resource] = true
  end

  def add_resource web_resource
    @working_files.delete(web_resource)
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

  def files_to_add
    (untracked_files + changed_files).sort
  end

  def resources_to_add
    untracked_resources + changed_resources
  end

  # private

    def untracked_files
      filter_by_status(:untracked, scraped_resources + working_files)
    end

    def changed_files
      filter_by_status(:changed, scraped_resources + working_files)
    end

    def filter_by_status status_type, resources
      paths = resources.collect(&:git_path)
      paths = paths.collect {|p| p[/\.pdf\.txt$/] ? [p, p.sub('.pdf.txt','.txt'), p.sub('.pdf.txt','.xml')] : p }.flatten
      paths += resources.collect(&:headers_git_path)
      GitRepo.select_by_status(status_type, paths)
    end

    def untracked_resources
      filter_resources_by_status(:untracked, scraped_resources + working_files)
    end

    def changed_resources
      filter_resources_by_status(:changed, scraped_resources + working_files)
    end

    def filter_resources_by_status status_type, resources
      resource_by_path = resources.group_by(&:git_path)
      paths = GitRepo.select_by_status(status_type, resource_by_path.keys)    
      paths.collect { |path| resource_by_path[path] }.flatten
    end

    def set_start_time
      self.start_time = Time.now
    end

    def initialize_working_files
      @working_files = {}
    end
end
