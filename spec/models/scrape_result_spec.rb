require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeResult do
  before(:each) do
    @scrape_result = ScrapeResult.new
  end

  describe 'on creation' do
    before(:each) do
      @scrape_result.save
    end

    it "should be valid" do
      @scrape_result.should be_valid
    end
    
    it 'should have start time set' do
      @scrape_result.start_time.should_not be_nil
    end
  end
  
end
