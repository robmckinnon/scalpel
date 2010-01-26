class CreateScrapers < ActiveRecord::Migration
  def self.up
    create_table :scrapers, :force => true do |t|
      t.string :name
      t.text :uri
      t.string :last_modified
      t.string :etag
      t.boolean :pdftotext_layout

      t.timestamps
    end
  end

  def self.down
    drop_table :scrapers
  end
end
