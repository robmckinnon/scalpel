require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrapers/index.html.haml" do
  include ScrapersHelper
  
  before(:each) do
    scraper_98 = mock_model(Scraper)
    scraper_98.should_receive(:name).and_return("MyString")
    scraper_98.stub!(:schedule_every).and_return("1.day")
    scraper_99 = mock_model(Scraper)
    scraper_99.should_receive(:name).and_return("MyString")
    scraper_99.stub!(:schedule_every).and_return("1.day")

    assigns[:scrapers_by_namespace] = [['n1',[scraper_98]], ['n2',[scraper_99]]]

    template.stub!(:object_url).and_return(scraper_path(scraper_99))
    template.stub!(:new_object_url).and_return(new_scraper_path) 
    template.stub!(:edit_object_url).and_return(edit_scraper_path(scraper_99))
  end

  it "should render list of scrapers" do
    render "/scrapers/index.html.haml"
    response.should have_tag("li", /MyString/)
  end
end

