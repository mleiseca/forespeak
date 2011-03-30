class AddLastTransactionPositionIdToMarkets < ActiveRecord::Migration
  def self.up
    add_column :markets, :last_tranasction_position_id, :integer
  end

  def self.down
    remove_column :markets, :last_tranasction_position_id
  end
end
