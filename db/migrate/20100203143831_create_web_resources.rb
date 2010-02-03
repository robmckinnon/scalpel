class CreateWebResources < ActiveRecord::Migration
  def self.up
    create_table :web_resources, :force => true do |t|
      t.string :name
      t.text :uri
      t.string :last_modified
      t.string :etag
      t.boolean :pdftotext_layout

      t.timestamps
    end
    
    add_index :web_resource, :uri
  end

  def self.down
    drop_table :web_resources
  end
end
