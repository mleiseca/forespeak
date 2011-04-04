class RemoveBadLastTransactionColumnsFromMarket < ActiveRecord::Migration
  def self.up
    remove_column :markets, :last_tranasction_position_id
  end

  def self.down
    add_column :markets, :last_tranasction_position_id, :integer
  end
end
