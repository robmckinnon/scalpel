class ParseRunsController < ActionController::Base

  before_filter :find_parse_job
  protect_from_forgery :except => :update    

  def new
    @parse_run = @job.parse_runs.create
    @parse_run.start_run
    redirect_to :controller => :parse_jobs, :action => :show, :id => @parse_job_id
  end
  
  def update
    parse_run = @job.parse_runs.find(params[:id])
    if parse_run.update_attributes params[:parse_run]
      render :status => '200', :text => ''
    else
      render :status => '400', :text => ''
    end
  end
  
  private
    def find_parse_job
      @parse_job_id = params[:parse_job_id]
      return(redirect_to(parse_jobs_url)) unless @parse_job_id
      @job = ScrapeJob.find(@parse_job_id)
    end
end
