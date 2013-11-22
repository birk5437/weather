class AddAddressToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :address, :string
  end

  def self.down
  end
end
