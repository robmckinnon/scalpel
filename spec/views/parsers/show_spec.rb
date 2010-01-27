require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/parsers/show.html.haml" do
  include ParsersHelper
  
  before(:each) do
    @parser = mock_model(Parser)
    @parser.stub!(:name).and_return("MyString")
    @parser.stub!(:uri_pattern).and_return("MyText")
    @parser.stub!(:parser_file).and_return("MyString")
    @parser.stub!(:parse_runs).and_return []

    assigns[:parser] = @parser

    template.stub!(:edit_object_url).and_return(edit_parser_path(@parser)) 
    template.stub!(:collection_url).and_return(parsers_path) 
  end

  it "should render attributes in <p>" do
    render "/parsers/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
  end
end

