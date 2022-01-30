require 'rails_helper'

RSpec.describe Animal, type: :model do

  subject(:animal) do
    Animal.create(
      name: name,
      dob: dob,
      photos: [
        Photo.create(address: photo_link_one),
        Photo.create(address: photo_link_two),
      ]
    )
  end
  let(:name) { "James" }
  let(:dob) { Date.new(2022, 1, 20) }
  let(:photo_link_one) { "url to photo one" }
  let(:photo_link_two) { "url to photo two" }

  let(:mock_credentials) do
    OpenStruct.new(
      aws: {
        access_key_id: "123",
        secret_access_key: "345"
      }
    )
  end

  before do
    allow(Rails.application).to receive(:credentials).and_return(mock_credentials)
  end

  it { expect(animal.reload.name).to eq(name) }
  it { expect(animal.reload.dob).to eq(dob) }
end