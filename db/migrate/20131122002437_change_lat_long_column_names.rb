class ChangeLatLongColumnNames < ActiveRecord::Migration
  def self.up
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float

    Location.all.each do |l|
      l.latitude = l.lat.to_f
      l.longitude = l.long.to_f
      l.save
    end

  end

  def self.down
    remove_column :locations, :latitude
    remove_column :locations, :longitude
  end
end
