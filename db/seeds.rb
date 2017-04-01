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