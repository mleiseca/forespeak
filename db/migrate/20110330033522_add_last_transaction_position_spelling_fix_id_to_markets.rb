class AddLastTransactionPositionSpellingFixIdToMarkets < ActiveRecord::Migration
  def self.up
    add_column :markets, :last_transaction_position_id, :integer
  end

  def self.down
    remove_column :markets, :last_transaction_position_id
  end
end
