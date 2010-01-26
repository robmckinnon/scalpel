require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeRunsController do
  describe "route generation" do
    it "should map { :controller => 'scrape_runs', :action => 'new' } to /scrape_runs/new" do
      route_for(:controller => "scrape_runs", :action => "new", :scraper_id => "1").should == "/scrapers/1/scrape_runs/new"
    end
  
    it "should map { :controller => 'scrape_runs', :action => 'edit', :id => '1' } to /scrape_runs/1/edit" do
      route_for(:controller => "scrape_runs", :action => "edit", :id => "1", :scraper_id => "1").should == "/scrapers/1/scrape_runs/1/edit"
    end
  
    it "should map { :controller => 'scrape_runs', :action => 'update', :id => '1' } to /scrape_runs/1" do
      route_for(:controller => "scrape_runs", :action => "update", :id => "1", :scraper_id => "1").should == {:path => "/scrapers/1/scrape_runs/1", :method => :put}
    end
  
    it "should map { :controller => 'scrape_runs', :action => 'destroy', :id => '1' } to /scrape_runs/1" do
      route_for(:controller => "scrape_runs", :action => "destroy", :id => "1", :scraper_id => "1").should == {:path => "/scrapers/1/scrape_runs/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "should generate params { :controller => 'scrape_runs', action => 'index' } from GET /scrape_runs" do
      params_from(:get, "/scrapers/1/scrape_runs").should == {:controller => "scrape_runs", :action => "index", :scraper_id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_runs', action => 'new' } from GET /scrape_runs/new" do
      params_from(:get, "/scrapers/1/scrape_runs/new").should == {:controller => "scrape_runs", :action => "new", :scraper_id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_runs', action => 'create' } from POST /scrape_runs" do
      params_from(:post, "/scrapers/1/scrape_runs").should == {:controller => "scrape_runs", :action => "create", :scraper_id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_runs', action => 'show', id => '1' } from GET /scrape_runs/1" do
      params_from(:get, "/scrapers/1/scrape_runs/1").should == {:controller => "scrape_runs", :action => "show", :id => "1", :scraper_id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_runs', action => 'edit', id => '1' } from GET /scrape_runs/1;edit" do
      params_from(:get, "/scrapers/1/scrape_runs/1/edit").should == {:controller => "scrape_runs", :action => "edit", :id => "1", :scraper_id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_runs', action => 'update', id => '1' } from PUT /scrape_runs/1" do
      params_from(:put, "/scrapers/1/scrape_runs/1").should == {:controller => "scrape_runs", :action => "update", :id => "1", :scraper_id => "1"}
    end
  
    it "should generate params { :controller => 'scrape_runs', action => 'destroy', id => '1' } from DELETE /scrape_runs/1" do
      params_from(:delete, "/scrapers/1/scrape_runs/1").should == {:controller => "scrape_runs", :action => "destroy", :id => "1", :scraper_id => "1"}
    end
  end
end
