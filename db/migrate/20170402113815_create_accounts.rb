class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :cash
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :accounts, [:user_id, :updated_at]
  end
end
