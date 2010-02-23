class ScrapersController < ResourceController::Base
  
  def index
    @scrapers_by_namespace = Scraper.code_by_namespace
  end

end
