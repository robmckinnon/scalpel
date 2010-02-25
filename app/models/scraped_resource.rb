require 'hpricot'

class ScrapedResource < ActiveRecord::Base

  belongs_to :web_resource
  belongs_to :scrape_result

  def contents
    # GitRepo.data git_commit_sha, git_path
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

end
