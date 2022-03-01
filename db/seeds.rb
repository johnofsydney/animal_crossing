# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Breed.destroy_all
Photo.destroy_all
Animal.destroy_all

def name
  Faker::Name.first_name
end

def dob
  Faker::Date.birthday(max_age: 14)
end

def description
  Faker::Lorem.paragraph
end

def size
  %w[small medium large].sample
end

def sex
  %w[male female].sample
end

def species
  %w[dog cat other].sample
end

def address
  [
    'https://placedog.net/600',
    'https://placedog.net/601',
    'https://placedog.net/602',
    'https://placedog.net/603',
    'https://placedog.net/604',
    'https://placedog.net/605',
    'https://placedog.net/606',
    'https://placedog.net/607',
  ].sample
end

def random_number
  (1..3).to_a.sample
end

def random_boolean
  [true, false].sample
end

def photos
  (1..random_number)
    .to_a
    .map { Photo.create(address: address) }
end

%w[Alsatian Pug Staffy Schnauser Cavoodle].each do |breed|
  Breed.create(breed: breed)
end

def breeds
  Breed.all.shuffle.take(random_number)
end

20.times do
  Animal.create(
    name: name,
    dob: dob,
    description: description,
    size: size,
    sex: sex,
    species: species,
    photos: photos,
    breeds: breeds,
    good_with_small_children: random_boolean,
    good_with_older_children: random_boolean,
    good_with_other_dogs: random_boolean,
    good_with_cats: random_boolean,
    can_be_left_alone_during_working_hours: random_boolean,
    apartment_friendly: random_boolean,
    adopted_by_name: nil,
    adopted_by_email: nil,
    adopted_by_phone: nil,
    adopted_date: nil
  )
end

20.times do
  Animal.create(
    name: name,
    dob: dob,
    description: description,
    size: size,
    sex: sex,
    species: species,
    photos: photos,
    breeds: breeds,
    good_with_small_children: random_boolean,
    good_with_older_children: random_boolean,
    good_with_other_dogs: random_boolean,
    good_with_cats: random_boolean,
    can_be_left_alone_during_working_hours: random_boolean,
    apartment_friendly: random_boolean,
    adopted_by_name: Faker::Name.name,
    adopted_by_email: Faker::Internet.email,
    adopted_by_phone: Faker::PhoneNumber.cell_phone_with_country_code,
    adopted_date: Faker::Date.between(from: 2.years.ago, to: 2.days.ago)
  )
end
