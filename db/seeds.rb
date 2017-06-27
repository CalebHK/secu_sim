User.create!(name:  "Example User",
             email: "example@secusim.net",
             address: "596, Queen's road west",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@secusim.net"
  address = Faker::Address.street_address
  password = "password"
  User.create!(name:  name,
               email: email,
               address: address,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
4.times do
  name = Faker::Commerce.color
  cash = Faker::Number.decimal(3, 2)
  users.each { |user| user.accounts.create!(name: name, cash: cash, activated: true,
             activated_at: Time.zone.now) }
end

accounts = Account.all
accounts.each { |account|
  6.times do
    code = Faker::Internet.user_name(2..6)
    volume = Faker::Number.number(3)
    total_cost = Faker::Number.decimal(4, 3)
    activated_volume = volume.to_f
    account.inventories.create!(code: code, volume: volume, total_cost: total_cost, 
                                activated_volume: activated_volume)
  end
}