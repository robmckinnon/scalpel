require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ParsersController do
  describe "route generation" do

    it "should map { :controller => 'parsers', :action => 'index' } to /parsers" do
      route_for(:controller => "parsers", :action => "index").should == "/parsers"
    end
  
    it "should map { :controller => 'parsers', :action => 'new' } to /parsers/new" do
      route_for(:controller => "parsers", :action => "new").should == "/parsers/new"
    end
  
    it "should map { :controller => 'parsers', :action => 'show', :id => '1'} to /parsers/1" do
      route_for(:controller => "parsers", :action => "show", :id => "1").should == "/parsers/1"
    end
  
    it "should map { :controller => 'parsers', :action => 'edit', :id => '1' } to /parsers/1/edit" do
      route_for(:controller => "parsers", :action => "edit", :id => "1").should == "/parsers/1/edit"
    end
  
    it "should map { :controller => 'parsers', :action => 'update', :id => '1' } to /parsers/1" do
      route_for(:controller => "parsers", :action => "update", :id => "1").should == {:path => "/parsers/1", :method => :put}
    end
  
    it "should map { :controller => 'parsers', :action => 'destroy', :id => '1' } to /parsers/1" do
      route_for(:controller => "parsers", :action => "destroy", :id => "1").should == {:path => "/parsers/1", :method => :delete}
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'parsers', action => 'index' } from GET /parsers" do
      params_from(:get, "/parsers").should == {:controller => "parsers", :action => "index"}
    end
  
    it "should generate params { :controller => 'parsers', action => 'new' } from GET /parsers/new" do
      params_from(:get, "/parsers/new").should == {:controller => "parsers", :action => "new"}
    end
  
    it "should generate params { :controller => 'parsers', action => 'create' } from POST /parsers" do
      params_from(:post, "/parsers").should == {:controller => "parsers", :action => "create"}
    end
  
    it "should generate params { :controller => 'parsers', action => 'show', id => '1' } from GET /parsers/1" do
      params_from(:get, "/parsers/1").should == {:controller => "parsers", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'parsers', action => 'edit', id => '1' } from GET /parsers/1;edit" do
      params_from(:get, "/parsers/1/edit").should == {:controller => "parsers", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'parsers', action => 'update', id => '1' } from PUT /parsers/1" do
      params_from(:put, "/parsers/1").should == {:controller => "parsers", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'parsers', action => 'destroy', id => '1' } from DELETE /parsers/1" do
      params_from(:delete, "/parsers/1").should == {:controller => "parsers", :action => "destroy", :id => "1"}
    end
  end
end
