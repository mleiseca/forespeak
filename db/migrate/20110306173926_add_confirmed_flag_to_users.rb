class AddConfirmedFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmed, :boolean, :default => false
  end

  def self.down
    remove_column :users, :confirmed
  end
end
