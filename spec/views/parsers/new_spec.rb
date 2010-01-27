require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/parsers/new.html.haml" do
  include ParsersHelper
  
  before(:each) do
    @parser = mock_model(Parser)
    @parser.stub!(:new_record?).and_return(true)
    @parser.stub!(:name).and_return("MyString")
    @parser.stub!(:uri_pattern).and_return("MyText")
    @parser.stub!(:parser_file).and_return("MyString")
    assigns[:parser] = @parser


    template.stub!(:object_url).and_return(parser_path(@parser)) 
    template.stub!(:collection_url).and_return(parsers_path) 
  end

  it "should render new form" do
    render "/parsers/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", parsers_path) do
      with_tag("input#parser_name[name=?]", "parser[name]")
      with_tag("textarea#parser_uri_pattern[name=?]", "parser[uri_pattern]")
      with_tag("input#parser_parser_file[name=?]", "parser[parser_file]")
    end
  end
end


