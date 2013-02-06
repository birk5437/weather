class AddRequestCountToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :request_count, :integer, :default => 0
  end

  def self.down
    remove_column :locations, :request_count
  end
end
