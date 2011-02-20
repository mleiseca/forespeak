class FixingTransactionTypeOnPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :direction, :string    
  end

  def self.down
  end
end
