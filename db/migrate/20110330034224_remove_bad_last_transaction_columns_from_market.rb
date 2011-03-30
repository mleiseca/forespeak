class RemoveBadLastTransactionColumnsFromMarket < ActiveRecord::Migration
  def self.up
    remove_column :markets, :last_transaction_date
    remove_column :markets, :last_tranasaction_position_id
  end

  def self.down
    add_column :markets, :last_tranasaction_position_id, :integer
    add_column :markets, :last_transaction_date, :datetime
  end
end
