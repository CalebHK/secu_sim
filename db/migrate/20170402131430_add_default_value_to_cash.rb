class AddDefaultValueToCash < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :cash, :decimal, default: 0.00
  end
end
