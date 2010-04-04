require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GitRepo do

  before :each do
    GitRepo.stub!(:data_git_dir).and_return 'data_git_dir'
    FileUtils.stub!(:mkdir_p)
  end

  describe "when uri contains a ' char" do
    before do
      @uri = "http://libdems.org.uk/parliamentary_candidates_detail.aspx?name=Victor_D'Albert&pPK=d27a0d13-9969-4a17-aac7-16a2006a54ea.html"
      @type = 'text/html'
    end
    
    it "should create uri_file_name correctly" do
      GitRepo.uri_file_name(@uri, @type, nil).should == "data_git_dir/libdems.org.uk/parliamentary_candidates_detail.aspx/name=Victor_D_Albert__pPK=d27a0d13-9969-4a17-aac7-16a2006a54ea.html"
    end

    it 'should create file_name correctly' do
      GitRepo.file_name(@uri, nil).should == "data_git_dir/libdems.org.uk/parliamentary_candidates_detail.aspx/name=Victor_D_Albert__pPK=d27a0d13-9969-4a17-aac7-16a2006a54ea.html"
    end
  end
=begin
  describe "when content_type is application/binary and content_disposition is pdf attachment" do
    before do
      @uri = 'http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=313'
      @type = 'application/binary'
      @disposition = 'attachment; filename=ep_periballon_aeiforos_anapt.pdf'
    end
    it "should create uri_file_name correctly" do
      GitRepo.uri_file_name(@uri, @type, @disposition).should == 'data_git_dir/www.espa.gr/Shared/Download.aspx/cat=attachments__type=Documents__fileid=313.pdf'
    end
    
    it 'should create file_name correctly' do
      GitRepo.file_name(@uri, @disposition).should == 'data_git_dir/www.espa.gr/Shared/Download.aspx/cat=attachments__type=Documents__fileid=313'
    end
  end
=end
end
