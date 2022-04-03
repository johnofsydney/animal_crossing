# == Schema Information
#
# Table name: photos
#
#  id         :bigint           not null, primary key
#  address    :string
#  animal_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :photo do
    association :animal # this creates the necessary animal from animal factory
    # you can just write 'animal', but including 'association' aids clarity
    # animal
    address { 'http://web/address/slash.jpg' }
  end
end
