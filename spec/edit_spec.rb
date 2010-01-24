require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/scrape_runs/edit.html.haml" do
  include ScrapeRunsHelper
  
  before do
    @scrape_run = mock_model(ScrapeRun)
    @scrape_run.stub!(:response_code).and_return("1")
    @scrape_run.stub!(:last_modified).and_return("MyString")
    @scrape_run.stub!(:etag).and_return("MyString")
    @scrape_run.stub!(:content_type).and_return("MyString")
    @scrape_run.stub!(:content_length).and_return("1")
    @scrape_run.stub!(:response_header).and_return("MyText")
    @scrape_run.stub!(:uri).and_return("MyText")
    @scrape_run.stub!(:file_path).and_return("MyText")
    @scrape_run.stub!(:git_path).and_return("MyText")
    assigns[:scrape_run] = @scrape_run

    template.should_receive(:object_url).twice.and_return(scrape_run_path(@scrape_run)) 
    template.should_receive(:collection_url).and_return(scrape_runs_path) 
  end

  it "should render edit form" do
    render "/scrape_runs/edit.html.haml"
    
    response.should have_tag("form[action=#{scrape_run_path(@scrape_run)}][method=post]") do
      with_tag('input#scrape_run_response_code[name=?]', "scrape_run[response_code]")
      with_tag('input#scrape_run_last_modified[name=?]', "scrape_run[last_modified]")
      with_tag('input#scrape_run_etag[name=?]', "scrape_run[etag]")
      with_tag('input#scrape_run_content_type[name=?]', "scrape_run[content_type]")
      with_tag('input#scrape_run_content_length[name=?]', "scrape_run[content_length]")
      with_tag('textarea#scrape_run_response_header[name=?]', "scrape_run[response_header]")
      with_tag('textarea#scrape_run_uri[name=?]', "scrape_run[uri]")
      with_tag('textarea#scrape_run_file_path[name=?]', "scrape_run[file_path]")
      with_tag('textarea#scrape_run_git_path[name=?]', "scrape_run[git_path]")
    end
  end
end


