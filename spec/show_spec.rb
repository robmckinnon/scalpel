require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrape_runs/show.html.haml" do
  include ScrapeRunsHelper
  
  before(:each) do
    @scrape_run = mock_model(ScrapeRun)
    @scrape_run.stub!(:response_code).and_return("1")
    @scrape_run.stub!(:last_modified).and_return("MyString")
    @scrape_run.stub!(:etag).and_return("MyString")
    @scrape_run.stub!(:content_type).and_return("MyString")
    @scrape_run.stub!(:content_length).and_return("1")
    @scrape_run.stub!(:response_header).and_return("MyText")
    @scrape_run.stub!(:uri).and_return("MyText")
    @scrape_run.stub!(:file_path).and_return("MyText")
    @scrape_run.stub!(:git_path).and_return("MyText")

    assigns[:scrape_run] = @scrape_run

    template.stub!(:edit_object_url).and_return(edit_scrape_run_path(@scrape_run)) 
    template.stub!(:collection_url).and_return(scrape_runs_path) 
  end

  it "should render attributes in <p>" do
    render "/scrape_runs/show.html.haml"
    response.should have_text(/1/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/1/)
    response.should have_text(/MyText/)
    response.should have_text(/MyText/)
    response.should have_text(/MyText/)
    response.should have_text(/MyText/)
  end
end

