require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScrapeRunsController do

  describe "handling GET /web_resources/1/scrape_runs/new" do
    before(:each) do
      @web_resource_id = 1
      @web_resource = mock_model(WebResource)
      @web_resource.stub!(:start_scrape).and_return(nil)
      WebResource.stub!(:find).and_return @web_resource
    end
  
    def do_get
      get :new, :web_resource_id => @web_resource_id
    end

    it "should be successful" do
      do_get
      response.should be_redirect
    end
  
    it "should render new template" do
      do_get
      response.should redirect_to('http://test.host/web_resources/1')
    end
  
    it "should start a new scrape run" do
      @web_resource.should_receive(:start_scrape).and_return(nil)
      do_get
    end  
  end
=begin
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
=end
end
