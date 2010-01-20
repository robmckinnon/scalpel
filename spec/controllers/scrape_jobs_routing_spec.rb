require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeJobsController do
  describe "route generation" do

    it "should map { :controller => 'scrape_jobs', :action => 'index' } to /scrape_jobs" do
      route_for(:controller => "scrape_jobs", :action => "index").should == "/scrape_jobs"
    end
  
    it "should map { :controller => 'scrape_jobs', :action => 'new' } to /scrape_jobs/new" do
      route_for(:controller => "scrape_jobs", :action => "new").should == "/scrape_jobs/new"
    end
  
    it "should map { :controller => 'scrape_jobs', :action => 'show', :id => '1'} to /scrape_jobs/1" do
      route_for(:controller => "scrape_jobs", :action => "show", :id => "1").should == "/scrape_jobs/1"
    end
  
    it "should map { :controller => 'scrape_jobs', :action => 'edit', :id => '1' } to /scrape_jobs/1/edit" do
      route_for(:controller => "scrape_jobs", :action => "edit", :id => "1").should == "/scrape_jobs/1/edit"
    end
  
    it "should map { :controller => 'scrape_jobs', :action => 'update', :id => '1' } to /scrape_jobs/1" do
      route_for(:controller => "scrape_jobs", :action => "update", :id => "1").should == {:path => "/scrape_jobs/1", :method => :put}
    end
  
    it "should map { :controller => 'scrape_jobs', :action => 'destroy', :id => '1' } to /scrape_jobs/1" do
      route_for(:controller => "scrape_jobs", :action => "destroy", :id => "1").should == {:path => "/scrape_jobs/1", :method => :delete}
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'scrape_jobs', action => 'index' } from GET /scrape_jobs" do
      params_from(:get, "/scrape_jobs").should == {:controller => "scrape_jobs", :action => "index"}
    end
  
    it "should generate params { :controller => 'scrape_jobs', action => 'new' } from GET /scrape_jobs/new" do
      params_from(:get, "/scrape_jobs/new").should == {:controller => "scrape_jobs", :action => "new"}
    end
  
    it "should generate params { :controller => 'scrape_jobs', action => 'create' } from POST /scrape_jobs" do
      params_from(:post, "/scrape_jobs").should == {:controller => "scrape_jobs", :action => "create"}
    end
  
    it "should generate params { :controller => 'scrape_jobs', action => 'show', id => '1' } from GET /scrape_jobs/1" do
      params_from(:get, "/scrape_jobs/1").should == {:controller => "scrape_jobs", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_jobs', action => 'edit', id => '1' } from GET /scrape_jobs/1;edit" do
      params_from(:get, "/scrape_jobs/1/edit").should == {:controller => "scrape_jobs", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_jobs', action => 'update', id => '1' } from PUT /scrape_jobs/1" do
      params_from(:put, "/scrape_jobs/1").should == {:controller => "scrape_jobs", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_jobs', action => 'destroy', id => '1' } from DELETE /scrape_jobs/1" do
      params_from(:delete, "/scrape_jobs/1").should == {:controller => "scrape_jobs", :action => "destroy", :id => "1"}
    end
  end
end
