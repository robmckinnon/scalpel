class AddScheduleEveryToScrapers < ActiveRecord::Migration
  def self.up
    add_column :scrapers, :schedule_every, :string
  end

  def self.down
    remove_column :scrapers, :schedule_every, :string
  end
end
