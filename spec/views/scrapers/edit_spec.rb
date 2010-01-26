require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrapers/edit.html.haml" do
  include ScrapersHelper
  
  before do
    @scraper = mock_model(Scraper)
    @scraper.stub!(:name).and_return("MyString")
    @scraper.stub!(:uri).and_return("MyText")
    @scraper.stub!(:pdftotext_layout).and_return(false)
    assigns[:scraper] = @scraper

    template.should_receive(:object_url).twice.and_return(scraper_path(@scraper)) 
    template.should_receive(:collection_url).and_return(scrapers_path) 
  end

  it "should render edit form" do
    render "/scrapers/edit.html.haml"
    
    response.should have_tag("form[action=#{scraper_path(@scraper)}][method=post]") do
      with_tag('input#scraper_name[name=?]', "scraper[name]")
      with_tag('textarea#scraper_uri[name=?]', "scraper[uri]")
      with_tag('input#scraper_pdftotext_layout[name=?]', "scraper[pdftotext_layout]")
    end
  end
end


