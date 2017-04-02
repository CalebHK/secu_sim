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
  users.each { |user| user.accounts.create!(name: name, cash: cash) }
end