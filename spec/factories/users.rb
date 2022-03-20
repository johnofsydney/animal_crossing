FactoryBot.define do
  factory :user do
    email { 'jane.doe@email.com' }
    password { 'chicken' }
    password_confirmation { 'chicken' }
  end
end
