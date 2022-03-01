FactoryBot.define do
  factory :photo do
    association :animal # this creates the necessary animal from animal factory
    # you can just write 'animal', but including 'association' aids clarity
    # animal
    address { 'http://web/address/slash.jpg' }
  end
end
