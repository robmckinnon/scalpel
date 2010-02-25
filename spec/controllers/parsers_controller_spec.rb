require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ParsersController do
  describe "handling GET /parsers" do

    before(:each) do
      @namespace = 'namespace'
      @parser = mock_model(Parser)
      @code_by_namespace = [ [@namespace, [@parser]] ]
      Parser.stub!(:code_by_namespace).and_return(@code_by_namespace)
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
  
    it "should find all parsers" do
      Parser.should_receive(:code_by_namespace).and_return(@code_by_namespace)
      do_get
    end
  
    it "should assign the found parsers for the view" do
      do_get
      assigns[:parsers_by_namespace].should == @code_by_namespace
    end
  end

  describe "handling GET /parsers/1" do

    before(:each) do
      @parser = mock_model(Parser)
      Parser.stub!(:find).and_return(@parser)
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
  
    it "should find the parser requested" do
      Parser.should_receive(:find).with("1").and_return(@parser)
      do_get
    end
  
    it "should assign the found parser for the view" do
      do_get
      assigns[:parser].should equal(@parser)
    end
  end

  describe "handling GET /parsers/new" do

    before(:each) do
      @parser = mock_model(Parser)
      Parser.stub!(:new).and_return(@parser)
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
  
    it "should create an new parser" do
      Parser.should_receive(:new).and_return(@parser)
      do_get
    end
  
    it "should not save the new parser" do
      @parser.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new parser for the view" do
      do_get
      assigns[:parser].should equal(@parser)
    end
  end

  describe "handling GET /parsers/1/edit" do

    before(:each) do
      @parser = mock_model(Parser)
      Parser.stub!(:find).and_return(@parser)
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
  
    it "should find the parser requested" do
      Parser.should_receive(:find).and_return(@parser)
      do_get
    end
  
    it "should assign the found Parsers for the view" do
      do_get
      assigns[:parser].should equal(@parser)
    end
  end

  describe "handling POST /parsers" do

    before(:each) do
      @parser = mock_model(Parser, :to_param => "1")
      Parser.stub!(:new).and_return(@parser)
    end
    
    describe "with successful save" do
  
      def do_post
        @parser.should_receive(:save).and_return(true)
        post :create, :parser => {}
      end
  
      it "should create a new parser" do
        Parser.should_receive(:new).with({}).and_return(@parser)
        do_post
      end

      it "should redirect to the new parser" do
        do_post
        response.should redirect_to(parser_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @parser.should_receive(:save).and_return(false)
        post :create, :parser => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /parsers/1" do

    before(:each) do
      @parser = mock_model(Parser, :to_param => "1")
      Parser.stub!(:find).and_return(@parser)
    end
    
    describe "with successful update" do

      def do_put
        @parser.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the parser requested" do
        Parser.should_receive(:find).with("1").and_return(@parser)
        do_put
      end

      it "should update the found parser" do
        do_put
        assigns(:parser).should equal(@parser)
      end

      it "should assign the found parser for the view" do
        do_put
        assigns(:parser).should equal(@parser)
      end

      it "should redirect to the parser" do
        do_put
        response.should redirect_to(parser_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @parser.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /parsers/1" do

    before(:each) do
      @parser = mock_model(Parser, :destroy => true)
      Parser.stub!(:find).and_return(@parser)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the parser requested" do
      Parser.should_receive(:find).with("1").and_return(@parser)
      do_delete
    end
  
    it "should call destroy on the found parser" do
      @parser.should_receive(:destroy).and_return(true) 
      do_delete
    end
  
    it "should redirect to the parsers list" do
      do_delete
      response.should redirect_to(parsers_url)
    end
  end
end
