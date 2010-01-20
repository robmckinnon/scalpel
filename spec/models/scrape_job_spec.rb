require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeJob do
  before(:each) do
    @scrape_job = ScrapeJob.new
  end

  it "should be valid" do
    @scrape_job.should be_valid
  end
end
