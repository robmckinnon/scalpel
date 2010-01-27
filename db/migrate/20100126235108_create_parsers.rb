class CreateParsers < ActiveRecord::Migration
  def self.up
    create_table :parsers, :force => true do |t|
      t.string :name
      t.text :uri_pattern
      t.string :parser_file

      t.timestamps
    end
  end

  def self.down
    drop_table :parsers
  end
end
