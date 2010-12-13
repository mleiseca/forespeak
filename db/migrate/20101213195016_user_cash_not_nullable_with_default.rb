class UserCashNotNullableWithDefault < ActiveRecord::Migration
  def self.up
    User.update_all ["cash = 0"]
    change_column :users, :cash, :decimal, :null => false, :default => 0
  end

  def self.down
    change_column :users, :cash, :decimal
  end
end
