require 'faker'

40.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password'
  )

  movie = Movie.create!(
    title: Faker::Movie.title,
    year: Faker::Date.between(from: 100.years.ago, to: Date.today).year,
    user: user
  )
end
