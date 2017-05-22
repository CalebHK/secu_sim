class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :code
      t.references :account, foreign_key: true
      t.integer :volume
      t.integer :activated_volume
      t.decimal :total_cost
      t.string :company

      t.timestamps
    end
    add_index :inventories, [:account_id, :code]
  end
end
