# gem faker.different of create! and create method is it raises an exception for
# an invalid user instead return false. makes debugger easier than silent errors
User.create!(
  name:  "Võ Văn Danh", email: "danh13t1@gmail.com", password: "123456",
  password_confirmation: "123456", admin: true
)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(
    name: name, email: email, password: password,
    password_confirmation: password
  )
end
