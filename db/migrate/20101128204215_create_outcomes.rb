class CreateOutcomes < ActiveRecord::Migration
  def self.up
    create_table :outcomes do |t|
      t.integer :market_id
      t.string :description
      t.decimal :start_price

      t.timestamps
    end
  end

  def self.down
    drop_table :outcomes
  end
end
