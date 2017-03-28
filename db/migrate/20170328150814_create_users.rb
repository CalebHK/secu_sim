class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :gender
      t.string :education
      t.string :marital
      t.string :nationality
      t.string :bank
      t.string :bankaddress
      t.string :bankaccount
      t.string :tel

      t.timestamps
    end
  end
end
