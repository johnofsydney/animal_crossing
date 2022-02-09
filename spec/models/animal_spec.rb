require 'rails_helper'

RSpec.describe Animal, type: :model do
  subject(:animal) do
    Animal.create( # rubocop:disable RSpec/DescribedClass
      name: name,
      dob: dob,
      photos: [
        Photo.create(address: photo_link_one),
        Photo.create(address: photo_link_two)
      ]
    )
  end

  let(:name) { 'James' }
  let(:dob) { Date.new(2022, 1, 20) }
  let(:photo_link_one) { 'url to photo one' }
  let(:photo_link_two) { 'url to photo two' }

  it { expect(animal.name).to eq(name) }
  it { expect(animal.dob).to eq(dob) }

  context 'when the animal is a puppy' do
    let(:dob) { Date.today - 21 }

    it { expect(animal.age).to eq('3 weeks') }
    it { expect(animal.age_group).to eq('puppy') }
  end
end
