class AddSecurityToInventories < ActiveRecord::Migration[5.0]
  def change
    add_reference :inventories, :security, foreign_key: true
  end
end
