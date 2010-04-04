require 'uri'
require 'fileutils'
require 'process_lock'
require 'cmess/guess_encoding'
require 'iconv'
require 'git'

class GitRepo

  class << self
    
    def log text
      puts text
    end

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
    
    def git_repo force=false
      Dir.chdir git_dir
      @git_repo = Git.open('.')
    end

    def file_name uri, content_disposition
      parts = uri.chomp('/').sub(/^https?:\/\//,'').split(/\/|\?/).collect {|p| p[/^&?(.+)&?$/,1].gsub(':','_').gsub('&','__').gsub('(','_').gsub(')','_').gsub("'",'_') }
      File.join(data_git_dir, parts)
    end

    def uri_file_name uri, content_type, content_disposition
      uri_path = URI.parse(uri)
      if content_disposition && content_disposition[/^attachment; filename=(.+).pdf$/]
        file_type = 'pdf'
      else
        file_type = content_type.split('/').last.split(';').first
      end

      uri = "#{uri}index.#{file_type}" if uri_path == '/'
      file = file_name(uri, content_disposition)      
      file = "#{file}.#{file_type}" if File.extname(file).blank?

      path = File.dirname(file)
      FileUtils.mkdir_p(path) unless File.exist?(path)
      file
    end

    def open_parsed path
      name = "#{data_git_dir.sub('scraped','parsed')}/#{path}"
      IO.read(name)
    end

    def write_parsed path, data
      name = "#{data_git_dir.sub('scraped','parsed')}/#{path}"
      write_file name, data
    end
    
    def write_file name, contents
      log "writing file: #{name}"
      path = File.dirname name
      FileUtils.mkdir_p(path) unless File.exist?(path)
      File.open(name, 'w') do |f|
        f.write contents
      end
    end
    
    def read_file file_name
      content = IO.read(file_name)
      charset = CMess::GuessEncoding::Automatic.guess(content) 
      Iconv.conv('utf-8', charset, content)
    end

    def run cmd
      log cmd
      `#{cmd}`
    end

    def convert_pdf_file pdf_file
      text_file = "#{pdf_file.gsub(' ','_')}.txt"
      file = pdf_file.gsub(' ','\ ')
      run "pdftotext -enc UTF-8 -layout #{file} #{text_file}"
      run "pdftotext -enc UTF-8 #{file} #{text_file.sub(/\.pdf\.txt$/,'.txt')}"
      run "pdftohtml -xml #{file} #{text_file.sub(/\.pdf\.txt$/,'') }"
      text_file
    end

    def relative_git_path file
      file ? file.sub(git_dir,'').sub(/^\//,'') : nil
    end

    def git_status
      git_repo.status
    end
    
    def each_git_status_type &block
      the_status = git_status
      [:added, :changed, :deleted, :untracked].each do |type|
        files = the_status.send(type)
        yield type, files
      end
    end

    # returns hash of files with status_type, key is git_path
    def git_status_hash status_type
      state = git_status.send(status_type)
      state.inject({}) do |hash, item|
        hash[item[0]] = item[1]
        hash
      end
    end

    # returns list of git_paths that have specified status_type
    def select_by_git_status status_type, git_paths
      status = git_status_hash(status_type)
      git_paths.select {|git_path| status[git_path] }
    end
    
    # adds relative git_path to git repository, but does not commit
    def add_to_repo *git_paths
      git_paths.flatten.in_groups_of(10).each do |paths|
        paths = paths.compact
        log "adding: #{paths.join('  ')}"
        git_repo.add(paths)
      end
    end

    def last_commit
      git_repo.log.first
    end

    def last_by_message message
      last = last_commit
      if last && last.message == message
        last
      else
        raise Exception.new("no commit found for message: #{message}")
      end
    end

    # commits to git repository, add_to_git must be called first, returns git_commit_sha
    def commit_to_repo message
      log message
      result = git_repo.commit(message)
      log "---\n#{result}\n==="
      commit = last_by_message(message)
      git_commit_sha = commit ? commit.sha : nil
    end

    def data_from_repo git_commit_sha, git_path
      commit = git_repo.gcommit(git_commit_sha)
      if commit
        tree = commit.gtree
        blob = tree.blobs[git_path]
      else
        blob = nil
      end
        
      blob ? blob.contents : nil
    end

  end

end
