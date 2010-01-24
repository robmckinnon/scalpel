class ScrapeRunsController < ResourceController::Base

  before_filter :find_scrape_job

  protect_from_forgery :except => :update    

  def new
    @scrape_run = @job.scrape_runs.create
    redirect_to :controller => :scrape_jobs, :action => :show, :id => @scrape_job_id
  end
  
  private
    def find_scrape_job
      @scrape_job_id = params[:scrape_job_id]
      return(redirect_to(scrape_jobs_url)) unless @scrape_job_id
      @job = ScrapeJob.find(@scrape_job_id)
    end
end
