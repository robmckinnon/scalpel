require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebResourcesController do
  describe "route generation" do

    it "should map { :controller => 'web_resources', :action => 'index' } to /web_resources" do
      route_for(:controller => "web_resources", :action => "index").should == "/web_resources"
    end
  
    it "should map { :controller => 'web_resources', :action => 'new' } to /web_resources/new" do
      route_for(:controller => "web_resources", :action => "new").should == "/web_resources/new"
    end
  
    it "should map { :controller => 'web_resources', :action => 'show', :id => '1'} to /web_resources/1" do
      route_for(:controller => "web_resources", :action => "show", :id => "1").should == "/web_resources/1"
    end
  
    it "should map { :controller => 'web_resources', :action => 'edit', :id => '1' } to /web_resources/1/edit" do
      route_for(:controller => "web_resources", :action => "edit", :id => "1").should == "/web_resources/1/edit"
    end
  
    it "should map { :controller => 'web_resources', :action => 'update', :id => '1' } to /web_resources/1" do
      route_for(:controller => "web_resources", :action => "update", :id => "1").should == {:path => "/web_resources/1", :method => :put}
    end
  
    it "should map { :controller => 'web_resources', :action => 'destroy', :id => '1' } to /web_resources/1" do
      route_for(:controller => "web_resources", :action => "destroy", :id => "1").should == {:path => "/web_resources/1", :method => :delete}
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'web_resources', action => 'index' } from GET /web_resources" do
      params_from(:get, "/web_resources").should == {:controller => "web_resources", :action => "index"}
    end
  
    it "should generate params { :controller => 'web_resources', action => 'new' } from GET /web_resources/new" do
      params_from(:get, "/web_resources/new").should == {:controller => "web_resources", :action => "new"}
    end
  
    it "should generate params { :controller => 'web_resources', action => 'create' } from POST /web_resources" do
      params_from(:post, "/web_resources").should == {:controller => "web_resources", :action => "create"}
    end
  
    it "should generate params { :controller => 'web_resources', action => 'show', id => '1' } from GET /web_resources/1" do
      params_from(:get, "/web_resources/1").should == {:controller => "web_resources", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'web_resources', action => 'edit', id => '1' } from GET /web_resources/1;edit" do
      params_from(:get, "/web_resources/1/edit").should == {:controller => "web_resources", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'web_resources', action => 'update', id => '1' } from PUT /web_resources/1" do
      params_from(:put, "/web_resources/1").should == {:controller => "web_resources", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'web_resources', action => 'destroy', id => '1' } from DELETE /web_resources/1" do
      params_from(:delete, "/web_resources/1").should == {:controller => "web_resources", :action => "destroy", :id => "1"}
    end
  end
end
