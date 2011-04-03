class AddLastTradeAllowedDateToMarkets < ActiveRecord::Migration
  def self.up
    add_column :markets, :last_trade_allowed_date, :datetime
  end

  def self.down
    remove_column :markets, :last_trade_allowed_date
  end
end
