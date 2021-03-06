require 'hpricot'

class ScrapedResource < ActiveRecord::Base

  belongs_to :web_resource
  belongs_to :scrape_result

  def uri
    web_resource.uri
  end

  def xml_pdf_contents
    web_resource.xml_pdf_contents
  end

  def plain_pdf_contents
    web_resource.plain_pdf_contents
  end

  def contents
    # GitRepo.data git_commit_sha, git_path <- use this instead!!!
    web_resource.contents
  end

  def uri
    web_resource.uri
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
  
  def headers_git_path
    GitRepo.relative_git_path(headers_file)
  end

  def headers_file
    if web_resource_id
      web_resource.headers_file
    else
      nil
    end
  end

end
