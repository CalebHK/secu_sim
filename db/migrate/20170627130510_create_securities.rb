class CreateSecurities < ActiveRecord::Migration[5.0]
  def change
    create_table :securities do |t|
      t.string  :code
      t.string  :market

      t.timestamps
    end
  end
end
