require 'uri'
require 'fileutils'
require 'grit'

class GitRepo

  class << self
    def data_git_dir= dir
      FileUtils.mkdir_p dir unless File.exist? dir
      @data_git_dir = dir
    end

    def data_git_dir
      @data_git_dir
    end
    
    def git_dir= dir
      @git_dir = dir
    end

    def git_dir
      @git_dir
    end
    
    def git_repo force=false
      if !@repo || force
        Dir.chdir git_dir
        @repo = Grit::Repo.new('.')
      end
      @repo
    end

    def repo force=false
      git_repo force
    end

    def file_name uri
      parts = uri.chomp('/').sub(/^https?:\/\//,'').split(/\/|\?/).collect {|p| p[/^&?(.+)&?$/,1].gsub('&','__')}
      File.join(data_git_dir, parts)
    end
    
    def uri_file_name uri, content_type
      uri_path = URI.parse(uri)
      file_type = content_type.split('/').last.split(';').first

      if uri_path == '/'
        uri = "#{uri}index.#{file_type}"
      end
      file = file_name(uri)
      
      if File.extname(file) == ''
        file = "#{file}.#{file_type}"
      end

      path = File.dirname file
      FileUtils.mkdir_p(path) unless File.exist?(path)
      file
    end

    def write_file name, contents
      File.open(name, 'w') do |f|
        f.write contents
      end      
    end

    def relative_git_path file
      file.sub(git_dir,'').sub(/^\//,'')
    end

    def rescue_if_git_timeout &block
      begin
        yield repo
      rescue Grit::Git::GitTimeout => e
        puts e.class.name
        puts e.to_s
        puts e.backtrace.select{|x| x[/app\/models/]}.join("\n")
        sleep 5
        repo(force=true)
        rescue_if_git_timeout &block
      end      
    end

    # adds to git repository, but does not commit, returns git_path
    def add_to_git file_name, text
      write_file(file_name, text)
      git_path = relative_git_path(file_name)
      puts "adding: #{git_path}"
      repo.add(git_path)
      git_path
    end

    # commits to git repository, add_to_git must be called first, returns git_commit_sha
    def commit_to_git message
      puts message
      result = rescue_if_git_timeout do |repository|
        repository.commit_index(message)
      end
      puts "---\n#{result}\n==="

      commit = rescue_if_git_timeout do |repository|
        if result[/nothing added to commit/] || result[/nothing to commit/]
          nil
        else
          repository.commits.detect {|c| c.message == message}
        end
      end

      git_commit_sha = commit ? commit.id : nil
    end
    
    def data git_commit_sha, git_path
      commit = git_repo.commit git_commit_sha
      blob = commit ? (commit.tree / git_path) : nil
      blob ? blob.data : nil
    end

  end

end
