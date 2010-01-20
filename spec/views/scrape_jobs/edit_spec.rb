require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrape_jobs/edit.html.haml" do
  include ScrapeJobsHelper
  
  before do
    @scrape_job = mock_model(ScrapeJob)
    @scrape_job.stub!(:name).and_return("MyString")
    @scrape_job.stub!(:uri).and_return("MyText")
    @scrape_job.stub!(:pdftotext_layout).and_return(false)
    assigns[:scrape_job] = @scrape_job

    template.should_receive(:object_url).twice.and_return(scrape_job_path(@scrape_job)) 
    template.should_receive(:collection_url).and_return(scrape_jobs_path) 
  end

  it "should render edit form" do
    render "/scrape_jobs/edit.html.haml"
    
    response.should have_tag("form[action=#{scrape_job_path(@scrape_job)}][method=post]") do
      with_tag('input#scrape_job_name[name=?]', "scrape_job[name]")
      with_tag('textarea#scrape_job_uri[name=?]', "scrape_job[uri]")
      with_tag('input#scrape_job_pdftotext_layout[name=?]', "scrape_job[pdftotext_layout]")
    end
  end
end


