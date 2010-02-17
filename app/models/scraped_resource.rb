require 'hpricot'

class ScrapedResource < ActiveRecord::Base
  
  belongs_to :web_resource
  belongs_to :scrape_result

  def contents
    repo = ScrapeRunJob.git_repo
    commit = repo.commit git_commit_sha
    blob = commit ? (commit.tree / git_path) : nil
    blob ? blob.data : nil
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

end
