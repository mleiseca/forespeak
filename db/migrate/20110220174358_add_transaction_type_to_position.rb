class AddTransactionTypeToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :transaction_type, :type
  end

  def self.down
    remove_column :positions, :transaction_type
  end
end
