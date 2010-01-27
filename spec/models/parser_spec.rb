require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Parser do
  before(:each) do
    @parser = Parser.new
  end

  it "should be valid" do
    @parser.should be_valid
  end
end
