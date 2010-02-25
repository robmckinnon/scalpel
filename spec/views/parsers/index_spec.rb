require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/parsers/index.html.haml" do
  include ParsersHelper
  
  before(:each) do
    parser_98 = mock_model(Parser)
    parser_98.should_receive(:name).and_return("MyString")
    # parser_98.should_receive(:parser_file).and_return("MyString")
    parser_99 = mock_model(Parser)
    parser_99.should_receive(:name).and_return("MyString")
    # parser_99.should_receive(:parser_file).and_return("MyString")

    assigns[:parsers_by_namespace] = [['n1',[parser_98]], ['n2',[parser_99]]]

    template.stub!(:object_url).and_return(parser_path(parser_99))
    template.stub!(:new_object_url).and_return(new_parser_path) 
    template.stub!(:edit_object_url).and_return(edit_parser_path(parser_99))
  end

  it "should render list of parsers" do
    render "/parsers/index.html.haml"
    response.should have_tag("li", /MyString/)
  end
end

