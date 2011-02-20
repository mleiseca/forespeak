class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.integer :outcome_id
      t.integer :user_id
      t.decimal :delta_user_shares
      t.decimal :delta_user_account_value
      t.decimal :total_user_shares
      t.string :type
      t.decimal :outcome_price
      t.timestamp :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end
