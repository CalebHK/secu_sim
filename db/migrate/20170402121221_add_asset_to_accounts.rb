class AddAssetToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :asset, :decimal, default: 0.00
    add_index :accounts, [:cash, :asset]
  end
end
