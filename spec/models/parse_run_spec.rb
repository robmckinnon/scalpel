require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ParseRun do
  before(:each) do
    @parse_run = ParseRun.new
  end

  it "should be valid" do
    @parse_run.should be_valid
  end
end
