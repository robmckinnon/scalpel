require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeRunsController do
  describe "handling GET /scrape_runs" do

    before(:each) do
      @scrape_job = mock_model(ScrapeJob)
      @scrape_run = mock_model(ScrapeRun)
      ScrapeRun.stub!(:find).and_return([@scrape_run])
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
  
    it "should find all scrape_runs" do
      ScrapeRun.should_receive(:find).with(:all).and_return([@scrape_run])
      do_get
    end
  
    it "should assign the found scrape_runs for the view" do
      do_get
      assigns[:scrape_runs].should == [@scrape_run]
    end
  end

  describe "handling GET /scrape_runs/1" do

    before(:each) do
      @scrape_run = mock_model(ScrapeRun)
      ScrapeRun.stub!(:find).and_return(@scrape_run)
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
  
    it "should find the scrape_run requested" do
      ScrapeRun.should_receive(:find).with("1").and_return(@scrape_run)
      do_get
    end
  
    it "should assign the found scrape_run for the view" do
      do_get
      assigns[:scrape_run].should equal(@scrape_run)
    end
  end

  describe "handling GET /scrape_runs/new" do

    before(:each) do
      @scrape_run = mock_model(ScrapeRun)
      ScrapeRun.stub!(:new).and_return(@scrape_run)
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
  
    it "should create an new scrape_run" do
      ScrapeRun.should_receive(:new).and_return(@scrape_run)
      do_get
    end
  
    it "should not save the new scrape_run" do
      @scrape_run.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new scrape_run for the view" do
      do_get
      assigns[:scrape_run].should equal(@scrape_run)
    end
  end

  describe "handling GET /scrape_runs/1/edit" do

    before(:each) do
      @scrape_run = mock_model(ScrapeRun)
      ScrapeRun.stub!(:find).and_return(@scrape_run)
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
  
    it "should find the scrape_run requested" do
      ScrapeRun.should_receive(:find).and_return(@scrape_run)
      do_get
    end
  
    it "should assign the found ScrapeRuns for the view" do
      do_get
      assigns[:scrape_run].should equal(@scrape_run)
    end
  end

  describe "handling POST /scrape_runs" do

    before(:each) do
      @scrape_run = mock_model(ScrapeRun, :to_param => "1")
      ScrapeRun.stub!(:new).and_return(@scrape_run)
    end
    
    describe "with successful save" do
  
      def do_post
        @scrape_run.should_receive(:save).and_return(true)
        post :create, :scrape_run => {}
      end
  
      it "should create a new scrape_run" do
        ScrapeRun.should_receive(:new).with({}).and_return(@scrape_run)
        do_post
      end

      it "should redirect to the new scrape_run" do
        do_post
        response.should redirect_to(scrape_run_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @scrape_run.should_receive(:save).and_return(false)
        post :create, :scrape_run => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /scrape_runs/1" do

    before(:each) do
      @scrape_run = mock_model(ScrapeRun, :to_param => "1")
      ScrapeRun.stub!(:find).and_return(@scrape_run)
    end
    
    describe "with successful update" do

      def do_put
        @scrape_run.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the scrape_run requested" do
        ScrapeRun.should_receive(:find).with("1").and_return(@scrape_run)
        do_put
      end

      it "should update the found scrape_run" do
        do_put
        assigns(:scrape_run).should equal(@scrape_run)
      end

      it "should assign the found scrape_run for the view" do
        do_put
        assigns(:scrape_run).should equal(@scrape_run)
      end

      it "should redirect to the scrape_run" do
        do_put
        response.should redirect_to(scrape_run_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @scrape_run.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /scrape_runs/1" do

    before(:each) do
      @scrape_run = mock_model(ScrapeRun, :destroy => true)
      ScrapeRun.stub!(:find).and_return(@scrape_run)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the scrape_run requested" do
      ScrapeRun.should_receive(:find).with("1").and_return(@scrape_run)
      do_delete
    end
  
    it "should call destroy on the found scrape_run" do
      @scrape_run.should_receive(:destroy).and_return(true) 
      do_delete
    end
  
    it "should redirect to the scrape_runs list" do
      do_delete
      response.should redirect_to(scrape_runs_url)
    end
  end
end
