class CreateParseRuns < ActiveRecord::Migration
  def self.up
    create_table :parse_runs, :force => true do |t|
      t.string :scrape_run_uri
      t.string :scrape_commit_sha
      t.text :scrape_git_path
      t.string :commit_sha
      t.text :git_path
      t.integer :parser_id

      t.timestamps
    end
    
    add_index :parse_runs, :parser_id
  end

  def self.down
    drop_table :parse_runs
  end
end
