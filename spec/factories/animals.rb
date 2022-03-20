FactoryBot.define do
  factory :animal do
    name    { Faker::Name.first_name }
    dob     { Faker::Date.birthday(max_age: 14) }
    description { Faker::Lorem.paragraph }
    size { 'small' }
    sex { 'male' }
    species { 'dog' }

    factory :animal_with_photos do
      transient do
        photos_count { 5 }
      end

      after(:create) do |animal, evaluator|
        create_list(:photo, evaluator.photos_count, animal: animal)

        animal.reload
      end
    end
  end
end

# create(:animal).photos.count => 0
# create(:animal_with_photos).photos.count => 5
# create(:animal_with_photos, photos_count:15).photos.count => 15
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#rspec
