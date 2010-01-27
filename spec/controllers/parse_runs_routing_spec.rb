require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ParseRunsController do
  describe "route generation" do
    it "should map { :controller => 'parse_runs', :action => 'new' } to /parse_runs/new" do
      route_for(:controller => "parse_runs", :action => "new", :parser_id => "1").should == "/parsers/1/parse_runs/new"
    end
  
    it "should map { :controller => 'parse_runs', :action => 'edit', :id => '1' } to /parse_runs/1/edit" do
      route_for(:controller => "parse_runs", :action => "edit", :id => "1", :parser_id => "1").should == "/parsers/1/parse_runs/1/edit"
    end
  
    it "should map { :controller => 'parse_runs', :action => 'update', :id => '1' } to /parse_runs/1" do
      route_for(:controller => "parse_runs", :action => "update", :id => "1", :parser_id => "1").should == {:path => "/parsers/1/parse_runs/1", :method => :put}
    end
  
    it "should map { :controller => 'parse_runs', :action => 'destroy', :id => '1' } to /parse_runs/1" do
      route_for(:controller => "parse_runs", :action => "destroy", :id => "1", :parser_id => "1").should == {:path => "/parsers/1/parse_runs/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "should generate params { :controller => 'parse_runs', action => 'index' } from GET /parse_runs" do
      params_from(:get, "/parsers/1/parse_runs").should == {:controller => "parse_runs", :action => "index", :parser_id => "1"}
    end
  
    it "should generate params { :controller => 'parse_runs', action => 'new' } from GET /parse_runs/new" do
      params_from(:get, "/parsers/1/parse_runs/new").should == {:controller => "parse_runs", :action => "new", :parser_id => "1"}
    end
  
    it "should generate params { :controller => 'parse_runs', action => 'create' } from POST /parse_runs" do
      params_from(:post, "/parsers/1/parse_runs").should == {:controller => "parse_runs", :action => "create", :parser_id => "1"}
    end
  
    it "should generate params { :controller => 'parse_runs', action => 'show', id => '1' } from GET /parse_runs/1" do
      params_from(:get, "/parsers/1/parse_runs/1").should == {:controller => "parse_runs", :action => "show", :id => "1", :parser_id => "1"}
    end
  
    it "should generate params { :controller => 'parse_runs', action => 'edit', id => '1' } from GET /parse_runs/1;edit" do
      params_from(:get, "/parsers/1/parse_runs/1/edit").should == {:controller => "parse_runs", :action => "edit", :id => "1", :parser_id => "1"}
    end
  
    it "should generate params { :controller => 'parse_runs', action => 'update', id => '1' } from PUT /parse_runs/1" do
      params_from(:put, "/parsers/1/parse_runs/1").should == {:controller => "parse_runs", :action => "update", :id => "1", :parser_id => "1"}
    end
  
    it "should generate params { :controller => 'parse_runs', action => 'destroy', id => '1' } from DELETE /parse_runs/1" do
      params_from(:delete, "/parsers/1/parse_runs/1").should == {:controller => "parse_runs", :action => "destroy", :id => "1", :parser_id => "1"}
    end
  end
end
