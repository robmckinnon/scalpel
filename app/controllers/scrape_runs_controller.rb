class ScrapeRunsController < ActionController::Base

  before_filter :find_web_resource
  protect_from_forgery :except => :update    

  def new
    @resource.start_scrape
    redirect_to :controller => :web_resources, :action => :show, :id => @web_resource_id
  end
  
  def update
    scrape_run = @resource.scrape_runs.find(params[:id])
    if scrape_run.update_attributes params[:scrape_run]
      render :status => '200', :text => ''
    else
      render :status => '400', :text => ''
    end
  end
  
  private
    def find_web_resource
      @web_resource_id = params[:web_resource_id]
      return(redirect_to(web_resources_url)) unless @web_resource_id
      @resource = WebResource.find(@web_resource_id)
    end
end
