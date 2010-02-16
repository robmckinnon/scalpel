class CreateScrapedResources < ActiveRecord::Migration
  def self.up
    create_table :scraped_resources do |t|
      t.integer :scrape_result_id
      t.integer :web_resource_id
      t.text :git_path
      t.string :git_commit_sha

      t.timestamps
    end

    add_index :scraped_resources, :scrape_result_id
    add_index :scraped_resources, :web_resource_id
  end

  def self.down
    drop_table :scraped_resources
  end
end
