require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebResourcesController do
  describe "handling GET /web_resources" do

    before(:each) do
      @web_resource = mock_model(WebResource)
      WebResource.stub!(:find).and_return([@web_resource])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all web_resources" do
      WebResource.should_receive(:find).with(:all).and_return([@web_resource])
      do_get
    end
  
    it "should assign the found web_resources for the view" do
      do_get
      assigns[:web_resources].should == [@web_resource]
    end
  end

  describe "handling GET /web_resources/1" do

    before(:each) do
      @web_resource = mock_model(WebResource)
      WebResource.stub!(:find).and_return(@web_resource)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the web_resource requested" do
      WebResource.should_receive(:find).with("1").and_return(@web_resource)
      do_get
    end
  
    it "should assign the found web_resource for the view" do
      do_get
      assigns[:web_resource].should equal(@web_resource)
    end
  end

  describe "handling GET /web_resources/new" do

    before(:each) do
      @web_resource = mock_model(WebResource)
      WebResource.stub!(:new).and_return(@web_resource)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new web_resource" do
      WebResource.should_receive(:new).and_return(@web_resource)
      do_get
    end
  
    it "should not save the new web_resource" do
      @web_resource.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new web_resource for the view" do
      do_get
      assigns[:web_resource].should equal(@web_resource)
    end
  end

  describe "handling GET /web_resources/1/edit" do

    before(:each) do
      @web_resource = mock_model(WebResource)
      WebResource.stub!(:find).and_return(@web_resource)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the web_resource requested" do
      WebResource.should_receive(:find).and_return(@web_resource)
      do_get
    end
  
    it "should assign the found WebResources for the view" do
      do_get
      assigns[:web_resource].should equal(@web_resource)
    end
  end

  describe "handling POST /web_resources" do

    before(:each) do
      @web_resource = mock_model(WebResource, :to_param => "1")
      WebResource.stub!(:new).and_return(@web_resource)
    end
    
    describe "with successful save" do
  
      def do_post
        @web_resource.should_receive(:save).and_return(true)
        post :create, :web_resource => {}
      end
  
      it "should create a new web_resource" do
        WebResource.should_receive(:new).with({}).and_return(@web_resource)
        do_post
      end

      it "should redirect to the new web_resource" do
        do_post
        response.should redirect_to(web_resource_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @web_resource.should_receive(:save).and_return(false)
        post :create, :web_resource => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /web_resources/1" do

    before(:each) do
      @web_resource = mock_model(WebResource, :to_param => "1")
      WebResource.stub!(:find).and_return(@web_resource)
    end
    
    describe "with successful update" do

      def do_put
        @web_resource.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the web_resource requested" do
        WebResource.should_receive(:find).with("1").and_return(@web_resource)
        do_put
      end

      it "should update the found web_resource" do
        do_put
        assigns(:web_resource).should equal(@web_resource)
      end

      it "should assign the found web_resource for the view" do
        do_put
        assigns(:web_resource).should equal(@web_resource)
      end

      it "should redirect to the web_resource" do
        do_put
        response.should redirect_to(web_resource_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @web_resource.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /web_resources/1" do

    before(:each) do
      @web_resource = mock_model(WebResource, :destroy => true)
      WebResource.stub!(:find).and_return(@web_resource)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the web_resource requested" do
      WebResource.should_receive(:find).with("1").and_return(@web_resource)
      do_delete
    end
  
    it "should call destroy on the found web_resource" do
      @web_resource.should_receive(:destroy).and_return(true) 
      do_delete
    end
  
    it "should redirect to the web_resources list" do
      do_delete
      response.should redirect_to(web_resources_url)
    end
  end
end
