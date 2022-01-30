require 'rails_helper'

RSpec.describe Animal, type: :model do
  # rubocop:disable RSpec/DescribedClass
  subject(:animal) do
    Animal.create(
      name: name,
      dob: dob,
      photos: [
        Photo.create(address: photo_link_one),
        Photo.create(address: photo_link_two)
      ]
    )
  end
  # rubocop:enable RSpec/DescribedClass

  let(:name) { 'James' }
  let(:dob) { Date.new(2022, 1, 20) }
  let(:photo_link_one) { 'url to photo one' }
  let(:photo_link_two) { 'url to photo two' }

  it { expect(animal.reload.name).to eq(name) }
  it { expect(animal.reload.dob).to eq(dob) }
end
