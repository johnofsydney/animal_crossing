Breed.destroy_all
Photo.destroy_all
Animal.destroy_all

def name
  Faker::Name.first_name
end

def dob
  [
    Faker::Date.between(from: 200.days.ago, to: 14.days.ago),
    Faker::Date.between(from: 36.months.ago, to: 6.months.ago),
    Faker::Date.between(from: 15.years.ago, to: 2.years.ago)
  ].sample
end

def description
  Faker::Lorem.paragraphs(number: 6).join(' ')
end

def size
  %w[small medium large].sample
end

def sex
  %w[male female].sample
end

def dog_photo_address
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

def cat_photo_address
  [
    'http://placekitten.com/200/300',
    'http://placekitten.com/300/300',
    'http://placekitten.com/400/300',
    'http://placekitten.com/400/400',
    'http://placekitten.com/400/500',
    'http://placekitten.com/400/500',
    'http://placekitten.com/500/500',
    'http://placekitten.com/600/400',
  ].sample
end

def other_animal_photo_address
  [
    'https://picsum.photos/200/300',
    'https://picsum.photos/300/300',
    'https://picsum.photos/400/300',
    'https://picsum.photos/300/400',
    'https://picsum.photos/400/400',
    'https://picsum.photos/500/400',
  ].sample
end

def random_number
  (4..6).to_a.sample
end

def random_boolean
  [true, false].sample
end

def dog_photos
  (3..random_number)
    .to_a
    .map { Photo.create(address: dog_photo_address) }
end

def cat_photos
  (3..random_number)
    .to_a
    .map { Photo.create(address: cat_photo_address) }
end

def other_animal_photos
  (3..random_number)
    .to_a
    .map { Photo.create(address: other_animal_photo_address) }
end

%w[Alsatian Pug Staffy Schnauser Cavoodle].each do |breed|
  Breed.create(breed: breed)
end

def dog_breeds
  Breed.all.shuffle.take(random_number)
end

def dog_description
  [
    "Loves walks, bones and children.",
    "Needs fences of more than 3m. Can jump and catch birds flying past.",
    "Was submitted to foster care by a tearful widow, after killing and eating her husband.",
    "Was submitted to foster care by a grateful widow, after killing and eating her husband.",
    "Will sleep all day. Probably won't notice you."
  ].sample + " " + description
end

def cat_description
  [
    "Sleeps all day. Will wake to drink milk.",
    "It's just a cat, it doesnt do anything, or care about you.",
  ].sample
end

def other_animal_description
  [
    "No one has ever seen an animal like this before. We don't know what it is.",
    "Cute feathers, nasty claws. You pay your money and you take your chances.",
  ].sample + " " + description
end

# make 100 dogs
100.times do
  Animal.create(
    name: name,
    description: dog_description,
    dob: dob,
    size: size,
    sex: sex,
    species: 'dog',
    photos: dog_photos,
    breeds: dog_breeds,
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

# make 30 cats
Animal.all.shuffle.take(30).each do |animal|
  animal.description = cat_description
  animal.species = 'cat'
  animal.photos = cat_photos
  animal.breeds = []
  animal.save
end

# make 20 other animals
Animal.dog.shuffle.take(20).each do |animal|
  animal.description = other_animal_description
  animal.species = 'other'
  animal.photos = other_animal_photos
  animal.breeds = []
  animal.save
end

# make 50 animals adopted
Animal.all.shuffle.take(50).each do |animal|
  animal.adopted_by_name = Faker::Name.name
  animal.adopted_by_email = Faker::Internet.email
  animal.adopted_by_phone = Faker::PhoneNumber.cell_phone_with_country_code
  animal.adopted_date = Faker::Date.between(from: 2.years.ago, to: 2.days.ago)
  animal.save
end
