require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/web_resources/index.html.haml" do
  include WebResourcesHelper
  
  before(:each) do
    web_resource_98 = mock_model(WebResource)
    web_resource_98.should_receive(:name).and_return("MyString")
    web_resource_98.should_receive(:uri).and_return("MyText")
    web_resource_98.should_receive(:last_modified).and_return("MyString")
    web_resource_98.should_receive(:etag).and_return("MyString")
    web_resource_98.should_receive(:pdftotext_layout).and_return(false)
    web_resource_99 = mock_model(WebResource)
    web_resource_99.should_receive(:name).and_return("MyString")
    web_resource_99.should_receive(:uri).and_return("MyText")
    web_resource_99.should_receive(:last_modified).and_return("MyString")
    web_resource_99.should_receive(:etag).and_return("MyString")
    web_resource_99.should_receive(:pdftotext_layout).and_return(false)

    assigns[:web_resources] = [web_resource_98, web_resource_99]

    template.stub!(:object_url).and_return(web_resource_path(web_resource_99))
    template.stub!(:new_object_url).and_return(new_web_resource_path) 
    template.stub!(:edit_object_url).and_return(edit_web_resource_path(web_resource_99))
  end

  it "should render list of web_resources" do
    render "/web_resources/index.html.haml"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    # response.should have_tag("tr>td", false, 2)
  end
end

