class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :code
      t.string :type
      t.references :account, foreign_key: true
      t.integer :volume
      t.decimal :price
      t.decimal :total_cost
      t.boolean :executed, default: false
      t.datetime :executed_at
      
      t.timestamps
    end
    add_index :orders, [:account_id, :created_at]
    add_index :orders, [:executed_at, :code]
  end
end
