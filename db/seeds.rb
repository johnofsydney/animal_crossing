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
  %w[Ruby Rex Nala Atlas Rolf Schnitzel Fido Maggie].sample
end

def dob
  [
    Date.new(2020, 6, 30),
    Date.new(2019, 9, 30),
    Date.new(2018, 3, 30),
  ].sample
end

def size
  %w[small medium large].sample
end

def sex
  %w[male female].sample
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
    size: size,
    sex: sex,
    photos: photos,
    breeds: breeds
  )
end
