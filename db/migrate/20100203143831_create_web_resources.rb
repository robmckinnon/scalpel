class CreateWebResources < ActiveRecord::Migration

  def self.up
    create_table :web_resources, :force => true do |t|
      t.string :name
      t.text :uri
      t.string :last_modified
      t.string :etag
      t.text :file_path
      t.text :git_path
      t.string :git_commit_sha
      t.boolean :pdftotext_layout

      t.timestamps
    end

    # add_index :web_resources, :uri
  end

  def self.down
    drop_table :web_resources
  end

end
