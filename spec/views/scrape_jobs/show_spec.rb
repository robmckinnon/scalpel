require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrape_jobs/show.html.haml" do
  include ScrapeJobsHelper
  
  before(:each) do
    @scrape_job = mock_model(ScrapeJob)
    @scrape_job.stub!(:name).and_return("MyString")
    @scrape_job.stub!(:uri).and_return("MyText")
    @scrape_job.stub!(:pdftotext_layout).and_return(false)

    assigns[:scrape_job] = @scrape_job

    template.stub!(:edit_object_url).and_return(edit_scrape_job_path(@scrape_job)) 
    template.stub!(:collection_url).and_return(scrape_jobs_path) 
  end

  it "should render attributes in <p>" do
    render "/scrape_jobs/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/als/)
  end
end

