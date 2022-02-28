FactoryBot.define do
  factory :animal do
    name    { Faker::Name.first_name }
    dob     { Faker::Date.birthday(max_age: 14) }
    description { Faker::Lorem.paragraph }
  end
end
