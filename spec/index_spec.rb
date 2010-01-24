require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrape_runs/index.html.haml" do
  include ScrapeRunsHelper
  
  before(:each) do
    scrape_run_98 = mock_model(ScrapeRun)
    scrape_run_98.should_receive(:response_code).and_return("1")
    scrape_run_98.should_receive(:last_modified).and_return("MyString")
    scrape_run_98.should_receive(:etag).and_return("MyString")
    scrape_run_98.should_receive(:content_type).and_return("MyString")
    scrape_run_98.should_receive(:content_length).and_return("1")
    scrape_run_98.should_receive(:response_header).and_return("MyText")
    scrape_run_98.should_receive(:uri).and_return("MyText")
    scrape_run_98.should_receive(:file_path).and_return("MyText")
    scrape_run_98.should_receive(:git_path).and_return("MyText")
    scrape_run_99 = mock_model(ScrapeRun)
    scrape_run_99.should_receive(:response_code).and_return("1")
    scrape_run_99.should_receive(:last_modified).and_return("MyString")
    scrape_run_99.should_receive(:etag).and_return("MyString")
    scrape_run_99.should_receive(:content_type).and_return("MyString")
    scrape_run_99.should_receive(:content_length).and_return("1")
    scrape_run_99.should_receive(:response_header).and_return("MyText")
    scrape_run_99.should_receive(:uri).and_return("MyText")
    scrape_run_99.should_receive(:file_path).and_return("MyText")
    scrape_run_99.should_receive(:git_path).and_return("MyText")

    assigns[:scrape_runs] = [scrape_run_98, scrape_run_99]

    template.stub!(:object_url).and_return(scrape_run_path(scrape_run_99))
    template.stub!(:new_object_url).and_return(new_scrape_run_path) 
    template.stub!(:edit_object_url).and_return(edit_scrape_run_path(scrape_run_99))
  end

  it "should render list of scrape_runs" do
    render "/scrape_runs/index.html.haml"
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyText", 2)
  end
end

