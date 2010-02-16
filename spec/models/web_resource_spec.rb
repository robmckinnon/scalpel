require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebResource do
  before(:each) do
    @web_resource = WebResource.new
  end

  it "should be valid" do
    @web_resource.should be_valid
  end
  
  describe 'when there are no contents' do
    before do
      @web_resource.stub!(:contents).and_return nil
    end
    describe 'and asked for links' do
      it 'should return empty array' do
        @web_resource.links.should be_empty
      end
    end
  end
  
  describe 'when contents are html' do
    before do
      @web_resource.stub!(:contents).and_return '<html><body><a href="dum">dee</a><a href="dee">dum</a></body></html>'
    end
    describe 'and asked for links' do
      it 'should return links' do
        links = @web_resource.links
        links.size.should == 2
        links.first['href'].should == 'dum'
        links.last['href'].should == 'dee'

        links.first.inner_text.should == 'dee'
        links.last.inner_text.should == 'dum'
      end
    end
  end
end
