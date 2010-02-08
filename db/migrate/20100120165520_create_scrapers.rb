class CreateScrapers < ActiveRecord::Migration
  def self.up
    create_table :scrapers, :force => true do |t|
      t.string :namespace
      t.string :name

      t.string :scraper_file

      t.timestamps
    end
    
    add_index :scrapers, :scraper_file
  end

  def self.down
    drop_table :scrapers
  end
end
