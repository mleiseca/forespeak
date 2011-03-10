class AddUserOutcomeIndexToPositions < ActiveRecord::Migration
  def self.up
    add_index :positions, [:user_id, :outcome_id]
  end

  def self.down
  end
end
