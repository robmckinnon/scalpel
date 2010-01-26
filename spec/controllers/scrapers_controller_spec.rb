require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapersController do
  describe "handling GET /scrapers" do

    before(:each) do
      @scraper = mock_model(Scraper)
      Scraper.stub!(:find).and_return([@scraper])
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
  
    it "should find all scrapers" do
      Scraper.should_receive(:find).with(:all).and_return([@scraper])
      do_get
    end
  
    it "should assign the found scrapers for the view" do
      do_get
      assigns[:scrapers].should == [@scraper]
    end
  end

  describe "handling GET /scrapers/1" do

    before(:each) do
      @scraper = mock_model(Scraper)
      Scraper.stub!(:find).and_return(@scraper)
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
  
    it "should find the scraper requested" do
      Scraper.should_receive(:find).with("1").and_return(@scraper)
      do_get
    end
  
    it "should assign the found scraper for the view" do
      do_get
      assigns[:scraper].should equal(@scraper)
    end
  end

  describe "handling GET /scrapers/new" do

    before(:each) do
      @scraper = mock_model(Scraper)
      Scraper.stub!(:new).and_return(@scraper)
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
  
    it "should create an new scraper" do
      Scraper.should_receive(:new).and_return(@scraper)
      do_get
    end
  
    it "should not save the new scraper" do
      @scraper.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new scraper for the view" do
      do_get
      assigns[:scraper].should equal(@scraper)
    end
  end

  describe "handling GET /scrapers/1/edit" do

    before(:each) do
      @scraper = mock_model(Scraper)
      Scraper.stub!(:find).and_return(@scraper)
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
  
    it "should find the scraper requested" do
      Scraper.should_receive(:find).and_return(@scraper)
      do_get
    end
  
    it "should assign the found Scrapers for the view" do
      do_get
      assigns[:scraper].should equal(@scraper)
    end
  end

  describe "handling POST /scrapers" do

    before(:each) do
      @scraper = mock_model(Scraper, :to_param => "1")
      Scraper.stub!(:new).and_return(@scraper)
    end
    
    describe "with successful save" do
  
      def do_post
        @scraper.should_receive(:save).and_return(true)
        post :create, :scraper => {}
      end
  
      it "should create a new scraper" do
        Scraper.should_receive(:new).with({}).and_return(@scraper)
        do_post
      end

      it "should redirect to the new scraper" do
        do_post
        response.should redirect_to(scraper_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @scraper.should_receive(:save).and_return(false)
        post :create, :scraper => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /scrapers/1" do

    before(:each) do
      @scraper = mock_model(Scraper, :to_param => "1")
      Scraper.stub!(:find).and_return(@scraper)
    end
    
    describe "with successful update" do

      def do_put
        @scraper.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the scraper requested" do
        Scraper.should_receive(:find).with("1").and_return(@scraper)
        do_put
      end

      it "should update the found scraper" do
        do_put
        assigns(:scraper).should equal(@scraper)
      end

      it "should assign the found scraper for the view" do
        do_put
        assigns(:scraper).should equal(@scraper)
      end

      it "should redirect to the scraper" do
        do_put
        response.should redirect_to(scraper_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @scraper.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /scrapers/1" do

    before(:each) do
      @scraper = mock_model(Scraper, :destroy => true)
      Scraper.stub!(:find).and_return(@scraper)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the scraper requested" do
      Scraper.should_receive(:find).with("1").and_return(@scraper)
      do_delete
    end
  
    it "should call destroy on the found scraper" do
      @scraper.should_receive(:destroy).and_return(true) 
      do_delete
    end
  
    it "should redirect to the scrapers list" do
      do_delete
      response.should redirect_to(scrapers_url)
    end
  end
end
