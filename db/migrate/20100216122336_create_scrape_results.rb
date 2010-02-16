class CreateScrapeResults < ActiveRecord::Migration
  def self.up
    create_table :scrape_results do |t|
      t.integer :scraper_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
    
    add_index :scrape_results, :scraper_id
  end

  def self.down
    drop_table :scrape_results
  end
end
