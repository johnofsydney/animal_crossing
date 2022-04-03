# == Schema Information
#
# Table name: animals
#
#  id                                     :bigint           not null, primary key
#  name                                   :string
#  dob                                    :date
#  description                            :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  size                                   :string
#  sex                                    :string
#  good_with_small_children               :boolean
#  good_with_older_children               :boolean
#  good_with_other_dogs                   :boolean
#  good_with_cats                         :boolean
#  can_be_left_alone_during_working_hours :boolean
#  apartment_friendly                     :boolean
#  adopted_by_name                        :string
#  adopted_by_email                       :string
#  adopted_by_phone                       :string
#  adopted_date                           :date
#  species                                :string
#
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
