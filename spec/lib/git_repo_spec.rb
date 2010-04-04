require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GitRepo do

  before :each do
    GitRepo.stub!(:data_git_dir).and_return 'data_git_dir'
    GitRepo.stub!(:log)
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
  
  describe 'when git_dir is set' do
    before do
      @git_dir = 'git_dir'
      GitRepo.git_dir= @git_dir
    end
    it 'should open git_repo correctly' do
      Dir.should_receive(:chdir).with @git_dir
      repo = mock('repo')
      Git.should_receive(:open).with('.').and_return repo
      GitRepo.git_repo.should == repo     
    end
  end
  
  describe 'when repo exists' do
    before do
      @repo = mock('repo')
      Git.stub!(:open).and_return @repo
    end

    describe 'when asked for data from repo' do
      it 'should return data if found' do
        text = 'text'
        blob = mock('blob', :contents => text)
        tree = mock('tree', :blobs => {'path' => blob})
        commit = mock('commit', :gtree => tree)
        @repo.should_receive(:gcommit).with('sha').and_return commit
        GitRepo.data_from_repo('sha', 'path').should == text
      end
    end
    describe 'when asked for last commit' do
      it 'should return first commit in git log' do
        commit = 'commit'
        log = mock('log', :first => commit)
        @repo.should_receive(:log).and_return log
        GitRepo.last_commit.should == commit
      end
    end
    
    describe 'when asked for last_by_message' do
      it 'should return first commit if message matches' do
        message = 'msg'
        commit = mock('commit', :message => message)
        GitRepo.should_receive(:last_commit).and_return commit
        GitRepo.last_by_message(message).should == commit
      end
      it 'should raise if message does not match' do
        commit = mock('commit', :message => 'red')
        GitRepo.should_receive(:last_commit).and_return commit
        lambda { GitRepo.last_by_message('blue') }.should raise_exception
      end
    end

    describe 'when asked for status' do
      it 'should return status' do
        status = mock('status')
        @repo.should_receive(:status).and_return status
        GitRepo.git_status.should == status
      end
    end
    
    describe 'when asked to add to repo' do
      it 'should add paths' do
        paths = ['added','added1']
        @repo.should_receive(:add).with(paths)
        GitRepo.add_to_repo(paths)
      end
    end
    
    describe 'when asked to commit to repo' do
      it 'should commit with message' do
        message = 'msg'
        @repo.should_receive(:commit).with(message).and_return '1 files changed, 1 insertions(+), 0 deletions(-)'
        commit = mock('commit', :sha => 'sha')
        GitRepo.should_receive(:last_by_message).with(message).and_return commit
        GitRepo.commit_to_repo(message).should == 'sha'
      end
    end

    describe 'when asked for status info' do
      before do
        @added =     [['added', 'git_status']]
        @untracked = [['untracked', 'git_status']]
        @deleted =   [['deleted', 'git_status']]
        @changed =   [['changed', 'git_status']]
        status = mock('status', :added => @added, :untracked => @untracked, :deleted => @deleted, :changed => @changed) 
        GitRepo.stub!(:git_status).and_return status
      end
      it 'should select by status' do
        GitRepo.should_receive(:git_status_hash).with(:added).and_return({'added1'=> 'git_status', 'added2' => 'git_status'})
        GitRepo.select_by_git_status(:added, ['added', 'added1']).should == ['added1']
      end
      it 'should return status hash' do
        hash = GitRepo.git_status_hash(:added)
        hash[@added[0]].should == @added[1]

        hash = GitRepo.git_status_hash(:untracked)
        hash[@untracked[0]].should == @untracked[1]

        hash = GitRepo.git_status_hash(:deleted)
        hash[@deleted[0]].should == @deleted[1]

        hash = GitRepo.git_status_hash(:changed)
        hash[@changed[0]].should == @changed[1]
      end
      it 'should return each status' do
        GitRepo.each_git_status_type do |type, files|
          case type
          when :added
            files.should == @added
          when :untracked
            files.should == @untracked
          when :deleted
            files.should == @deleted
          when :changed
            files.should == @changed
          else
            raise Exception 'unexpected'
          end          
        end
      end
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
