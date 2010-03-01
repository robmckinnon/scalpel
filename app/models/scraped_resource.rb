require 'hpricot'

class ScrapedResource < ActiveRecord::Base

  belongs_to :web_resource
  belongs_to :scrape_result

  def contents
    # GitRepo.data git_commit_sha, git_path <- use this instead!!!
    web_resource.contents
  end

  def hpricot_doc
    if contents
      @doc ||= Hpricot contents
    else
      nil
    end
  end

  def links
    contents ? (hpricot_doc/'a') : []
  end
  
  def headers_file
    if web_resource_id && git_path && git_commit_sha
      run = ScrapeRun.find_by_web_resource_id_and_git_path_and_git_commit_sha(web_resource_id, git_path, git_commit_sha)
      if run
        run.headers_file
      else
        nil
      end
    else
      nil
    end
  end

end
