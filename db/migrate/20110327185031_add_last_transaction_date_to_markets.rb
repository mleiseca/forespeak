class AddLastTransactionDateToMarkets < ActiveRecord::Migration
  def self.up
    add_column :markets, :last_transaction_date, :datetime
  end

  def self.down
    remove_column :markets, :last_transaction_date
  end
end
