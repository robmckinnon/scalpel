require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrapers/new.html.haml" do
  include ScrapersHelper
  
  before(:each) do
    @scraper = mock_model(Scraper)
    @scraper.stub!(:new_record?).and_return(true)
    @scraper.stub!(:name).and_return("MyString")
    @scraper.stub!(:namespace).and_return("namespace")
    @scraper.stub!(:scraper_file).and_return("scraper_file")
    @scraper.stub!(:pdftotext_layout).and_return(false)
    assigns[:scraper] = @scraper


    template.stub!(:object_url).and_return(scraper_path(@scraper)) 
    template.stub!(:collection_url).and_return(scrapers_path) 
  end

  it "should render new form" do
    render "/scrapers/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", scrapers_path) do
      with_tag("input#scraper_name[name=?]", "scraper[name]")
    end
  end
end


