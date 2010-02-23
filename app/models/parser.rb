require 'namespaced_code_file'

class Parser < ActiveRecord::Base
  
  has_many :parse_runs
  
  belongs_to :scraper

  include Acts::NamespacedCodeFile

  class << self
    def code_suffix
      '_parse'
    end
  end
end
