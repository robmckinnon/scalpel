class CreateScrapeRuns < ActiveRecord::Migration
  def self.up
    create_table :scrape_runs, :force => true do |t|
      t.integer :response_code
      t.string :last_modified
      t.string :etag
      t.string :content_type
      t.integer :content_length
      t.text :response_header
      t.text :uri
      t.text :file_path
      t.text :git_path
      t.string :git_commit_sha
      t.integer :scrape_job_id

      t.timestamps
    end
    
    add_index :scrape_runs, :scrape_job_id
  end

  def self.down
    drop_table :scrape_runs
  end
end
