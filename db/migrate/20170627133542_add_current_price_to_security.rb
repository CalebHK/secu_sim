class AddCurrentPriceToSecurity < ActiveRecord::Migration[5.0]
  def change
    add_column :securities, :current_price, :decimal
  end
end
