class AddPostTranasctionPriceToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :outcome_price_post_transaction, :decimal
  end

  def self.down
    remove_column :positions, :outcome_price_post_transaction
  end
end
