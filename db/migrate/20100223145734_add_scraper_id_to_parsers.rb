class AddScraperIdToParsers < ActiveRecord::Migration
  def self.up
    add_column :parsers, :scraper_id, :integer
    
    add_index :parsers, :scraper_id
  end

  def self.down
    remove_column :parsers, :scraper_id
  end
end
