require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeRun do
  before(:each) do
    @scrape_run = ScrapeRun.new :scrape_job_id => '1'
  end

  it "should be valid" do
    @scrape_run.should be_valid
  end
end
