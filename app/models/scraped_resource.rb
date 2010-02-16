class ScrapedResource < ActiveRecord::Base
  
  belongs_to :web_resource
  belongs_to :scrape_result

end
