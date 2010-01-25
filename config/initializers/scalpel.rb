# Be sure to restart your server when you modify this file.

config_file = File.expand_path(File.join(File.dirname(__FILE__),'..','scalpel.yml'))
settings = YAML.load_file(config_file)
data_git_dir = settings[RAILS_ENV]['data_git_dir']
ScrapeRunJob.data_git_dir= File.expand_path(File.join(RAILS_ROOT,data_git_dir))
