require 'uri'
require 'fileutils'
require 'grit'
require 'process_lock'

class GitRepo

  class << self
    
    def while_locked &block
      lock = ProcessLock.new(RAILS_ROOT + "/git_repo_lock.txt")
      while !lock.owner?             # loop while not owner
        lock.aquire! if !lock.alive? # aquire lock if it's not alive
        sleep 5 if !lock.owner?      # wait if lock not aquired
      end

      if lock.owner?
        yield(self)
      else
        while_locked &block
      end

      ensure
        lock.release!
    end
    
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
    
    def repo force=false
      if !@repo || force
        puts "changing to #{git_dir}"
        Dir.chdir git_dir
        @repo = Grit::Repo.new('.')
      end
      @repo
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

    def write_parsed path, data
      name = "#{data_git_dir.sub('scraped','parsed')}/#{path}"
      write_file name, data
    end
    
    def write_file name, contents
      puts "writing file: #{name}"
      path = File.dirname name
      FileUtils.mkdir_p(path) unless File.exist?(path)
      File.open(name, 'w') do |f|
        f.write contents
      end
    end

    def relative_git_path file
      file ? file.sub(git_dir,'').sub(/^\//,'') : nil
    end

    def rescue_if_git_timeout &block
      begin
        yield(repo)
      rescue Grit::Git::GitTimeout => e
        puts e.to_s
        puts e.backtrace.select{|x| x[/app\/models/]}.join("\n")
        sleep 5
        repo(force=true)
        puts 'trying again ...'
        rescue_if_git_timeout &block
      end      
    end

    def status
      rescue_if_git_timeout do |repository|
        repository.status
      end
    end
    
    def each_status_type &block
      the_status = status
      [:added, :changed, :deleted, :untracked].each do |type|
        files = the_status.send(type)
        yield type, files
      end
    end

    # returns hash of files with status_type, key is git_path
    def status_hash status_type
      state = repo.status.send(status_type)
      state.inject({}) do |hash, item|
        hash[item[0]] = item[1]
        hash
      end
    end

    # returns list of git_paths that have specified status_type
    def select_by_status status_type, git_paths
      status = status_hash(status_type)
      git_paths.select {|git_path| status[git_path] }
    end
    
    # adds relative git_path to git repository, but does not commit
    def add_to_git *git_paths
      puts "adding: #{git_paths.join('  ')}"
      rescue_if_git_timeout do |repository|
        repository.add(git_paths)
      end
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
      commit = rescue_if_git_timeout do |repository|
        repository.commit git_commit_sha
      end
      blob = commit ? (commit.tree / git_path) : nil
      blob ? blob.data : nil
    end

  end

end
