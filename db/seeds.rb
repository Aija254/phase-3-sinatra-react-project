require 'faker'

40.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password'
  )

  movie = User.create!(
    title: Faker::Title.name,
    year: Faker::Date.year,
    director: Faker::Name.firstName,
    genre: Faker::Name.lastName,
  )
  end

end