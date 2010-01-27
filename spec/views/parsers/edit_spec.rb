require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/parsers/edit.html.haml" do
  include ParsersHelper
  
  before do
    @parser = mock_model(Parser)
    @parser.stub!(:name).and_return("MyString")
    @parser.stub!(:uri_pattern).and_return("MyText")
    @parser.stub!(:parser_file).and_return("MyString")
    assigns[:parser] = @parser

    template.should_receive(:object_url).twice.and_return(parser_path(@parser)) 
    template.should_receive(:collection_url).and_return(parsers_path) 
  end

  it "should render edit form" do
    render "/parsers/edit.html.haml"
    
    response.should have_tag("form[action=#{parser_path(@parser)}][method=post]") do
      with_tag('input#parser_name[name=?]', "parser[name]")
      with_tag('textarea#parser_uri_pattern[name=?]', "parser[uri_pattern]")
      with_tag('input#parser_parser_file[name=?]', "parser[parser_file]")
    end
  end
end


