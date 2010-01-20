require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrape_jobs/index.html.haml" do
  include ScrapeJobsHelper
  
  before(:each) do
    scrape_job_98 = mock_model(ScrapeJob)
    scrape_job_98.should_receive(:name).and_return("MyString")
    scrape_job_98.should_receive(:uri).and_return("MyText")
    scrape_job_98.should_receive(:pdftotext_layout).and_return(false)
    scrape_job_99 = mock_model(ScrapeJob)
    scrape_job_99.should_receive(:name).and_return("MyString")
    scrape_job_99.should_receive(:uri).and_return("MyText")
    scrape_job_99.should_receive(:pdftotext_layout).and_return(false)

    assigns[:scrape_jobs] = [scrape_job_98, scrape_job_99]

    template.stub!(:object_url).and_return(scrape_job_path(scrape_job_99))
    template.stub!(:new_object_url).and_return(new_scrape_job_path) 
    template.stub!(:edit_object_url).and_return(edit_scrape_job_path(scrape_job_99))
  end

  it "should render list of scrape_jobs" do
    render "/scrape_jobs/index.html.haml"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    # response.should have_tag("tr>td", false, 2)
  end
end

