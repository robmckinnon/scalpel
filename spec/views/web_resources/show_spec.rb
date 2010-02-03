require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_resources/show.html.haml" do
  include WebResourcesHelper
  
  before(:each) do
    @web_resource = mock_model(WebResource)
    @web_resource.stub!(:name).and_return("MyString")
    @web_resource.stub!(:uri).and_return("MyText")
    @web_resource.stub!(:last_modified).and_return("MyString")
    @web_resource.stub!(:etag).and_return("MyString")
    @web_resource.stub!(:pdftotext_layout).and_return(false)
    @web_resource.stub!(:scrape_runs).and_return []

    assigns[:web_resource] = @web_resource

    template.stub!(:edit_object_url).and_return(edit_web_resource_path(@web_resource)) 
    template.stub!(:collection_url).and_return(web_resources_path) 
  end

  it "should render attributes in <p>" do
    render "/web_resources/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/als/)
  end
end

