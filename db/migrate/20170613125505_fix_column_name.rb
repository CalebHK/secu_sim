class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :type, :order_type
  end
end
