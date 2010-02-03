require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebResource do
  before(:each) do
    @web_resource = WebResource.new
  end

  it "should be valid" do
    @web_resource.should be_valid
  end
end
