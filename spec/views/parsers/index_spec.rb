require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/parsers/index.html.haml" do
  include ParsersHelper
  
  before(:each) do
    parser_98 = mock_model(Parser)
    parser_98.should_receive(:name).and_return("MyString")
    parser_98.should_receive(:uri_pattern).and_return("MyText")
    parser_98.should_receive(:parser_file).and_return("MyString")
    parser_99 = mock_model(Parser)
    parser_99.should_receive(:name).and_return("MyString")
    parser_99.should_receive(:uri_pattern).and_return("MyText")
    parser_99.should_receive(:parser_file).and_return("MyString")

    assigns[:parsers] = [parser_98, parser_99]

    template.stub!(:object_url).and_return(parser_path(parser_99))
    template.stub!(:new_object_url).and_return(new_parser_path) 
    template.stub!(:edit_object_url).and_return(edit_parser_path(parser_99))
  end

  it "should render list of parsers" do
    render "/parsers/index.html.haml"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

