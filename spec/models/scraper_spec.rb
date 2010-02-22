require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Scraper do
  before(:each) do
    @scraper = Scraper.new
  end

  it "should be valid" do
    @scraper.should be_valid
  end

  describe 'when it has no scrape_results' do
    it 'should return true for first_run?' do
      @scraper.first_run?.should be_true
    end
  end

  describe 'when it has previous scrape_results' do
    before do
      @scraper.stub!(:scrape_results).and_return [mock(ScrapeResult)]      
    end
    it 'should return false for first_run?' do
      @scraper.first_run?.should be_false
    end
  end

end
