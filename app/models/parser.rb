require 'namespaced_code_file'

class Parser < ActiveRecord::Base
  
  has_many :parse_runs
  
  belongs_to :scraper

  before_save :populate_scraper
  
  include Acts::NamespacedCodeFile

  class << self
    def code_suffix
      '_parse'
    end
    
    def values_from_line line
      line = String.new line
      line.strip!
      line.gsub!('  ', "\t")
      line.squeeze!("\t")
      line.split("\t")
    end

    def values_from_bounds line, bounds
      line = line.ljust(bounds.last)
      bounds.collect do |bound|
        if bound.is_a?(Array)
          line[(bound.first)..(bound.last)].strip
        else
          line[bound..(line.length-1)].strip
        end
      end
    end
    
    def print_column_histogram results
      by_col_index = results.group_by {|item| item.first}
      sorted = by_col_index.keys.sort
      0.upto(sorted.last) do |index|
        value = ''
        at_col = by_col_index[index]      
        at_col.size.times do |i|
          item = at_col[i]
          value += item[1]
        end if at_col
        puts "#{index} #{value}"
      end
    end

  end

  def run
    scrape_result = scraper ? scraper.last_scrape_result : nil
    parser = code_instance
    parser.perform scrape_result
  end
  
  def translate
    parser = code_instance
    parser.translate
  end
  
  def populate_scraper
    unless scraper_id
      scraper_file = parser_file.gsub('parse','scrape')
      if File.exist?(scraper_file)
        scraper = Scraper.find_by_scraper_file(scraper_file)
        if scraper
          self.scraper_id = scraper.id
        end
      end
    end
  end

end
