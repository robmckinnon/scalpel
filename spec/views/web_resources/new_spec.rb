require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_resources/new.html.haml" do
  include WebResourcesHelper
  
  before(:each) do
    @web_resource = mock_model(WebResource)
    @web_resource.stub!(:new_record?).and_return(true)
    @web_resource.stub!(:name).and_return("MyString")
    @web_resource.stub!(:uri).and_return("MyText")
    @web_resource.stub!(:last_modified).and_return("MyString")
    @web_resource.stub!(:etag).and_return("MyString")
    @web_resource.stub!(:pdftotext_layout).and_return(false)
    assigns[:web_resource] = @web_resource


    template.stub!(:object_url).and_return(web_resource_path(@web_resource)) 
    template.stub!(:collection_url).and_return(web_resources_path) 
  end

  it "should render new form" do
    render "/web_resources/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", web_resources_path) do
      with_tag("input#web_resource_name[name=?]", "web_resource[name]")
      with_tag("textarea#web_resource_uri[name=?]", "web_resource[uri]")
      with_tag("input#web_resource_last_modified[name=?]", "web_resource[last_modified]")
      with_tag("input#web_resource_etag[name=?]", "web_resource[etag]")
      with_tag("input#web_resource_pdftotext_layout[name=?]", "web_resource[pdftotext_layout]")
    end
  end
end


