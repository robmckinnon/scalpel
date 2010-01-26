require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapersController do
  describe "route generation" do

    it "should map { :controller => 'scrapers', :action => 'index' } to /scrapers" do
      route_for(:controller => "scrapers", :action => "index").should == "/scrapers"
    end
  
    it "should map { :controller => 'scrapers', :action => 'new' } to /scrapers/new" do
      route_for(:controller => "scrapers", :action => "new").should == "/scrapers/new"
    end
  
    it "should map { :controller => 'scrapers', :action => 'show', :id => '1'} to /scrapers/1" do
      route_for(:controller => "scrapers", :action => "show", :id => "1").should == "/scrapers/1"
    end
  
    it "should map { :controller => 'scrapers', :action => 'edit', :id => '1' } to /scrapers/1/edit" do
      route_for(:controller => "scrapers", :action => "edit", :id => "1").should == "/scrapers/1/edit"
    end
  
    it "should map { :controller => 'scrapers', :action => 'update', :id => '1' } to /scrapers/1" do
      route_for(:controller => "scrapers", :action => "update", :id => "1").should == {:path => "/scrapers/1", :method => :put}
    end
  
    it "should map { :controller => 'scrapers', :action => 'destroy', :id => '1' } to /scrapers/1" do
      route_for(:controller => "scrapers", :action => "destroy", :id => "1").should == {:path => "/scrapers/1", :method => :delete}
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'scrapers', action => 'index' } from GET /scrapers" do
      params_from(:get, "/scrapers").should == {:controller => "scrapers", :action => "index"}
    end
  
    it "should generate params { :controller => 'scrapers', action => 'new' } from GET /scrapers/new" do
      params_from(:get, "/scrapers/new").should == {:controller => "scrapers", :action => "new"}
    end
  
    it "should generate params { :controller => 'scrapers', action => 'create' } from POST /scrapers" do
      params_from(:post, "/scrapers").should == {:controller => "scrapers", :action => "create"}
    end
  
    it "should generate params { :controller => 'scrapers', action => 'show', id => '1' } from GET /scrapers/1" do
      params_from(:get, "/scrapers/1").should == {:controller => "scrapers", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'scrapers', action => 'edit', id => '1' } from GET /scrapers/1;edit" do
      params_from(:get, "/scrapers/1/edit").should == {:controller => "scrapers", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'scrapers', action => 'update', id => '1' } from PUT /scrapers/1" do
      params_from(:put, "/scrapers/1").should == {:controller => "scrapers", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'scrapers', action => 'destroy', id => '1' } from DELETE /scrapers/1" do
      params_from(:delete, "/scrapers/1").should == {:controller => "scrapers", :action => "destroy", :id => "1"}
    end
  end
end
