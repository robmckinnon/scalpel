require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrapers/show.html.haml" do
  include ScrapersHelper
  
  before(:each) do
    @scraper = mock_model(Scraper)
    @scraper.stub!(:name).and_return("MyString")
    @scraper.stub!(:uri).and_return("MyText")
    @scraper.stub!(:code).and_return("code")
    @scraper.stub!(:pdftotext_layout).and_return(false)

    assigns[:scraper] = @scraper

    template.stub!(:edit_object_url).and_return(edit_scraper_path(@scraper)) 
    template.stub!(:collection_url).and_return(scrapers_path) 
  end

  it "should render attributes in <p>" do
    render "/scrapers/show.html.haml"
    response.should have_text(/code/)
  end
end

