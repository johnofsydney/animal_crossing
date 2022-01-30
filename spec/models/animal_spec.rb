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

  let(:aws_credentials_mock) do
    {
      access_key_id: "123",
      secret_access_key: "456"

    }
  end

  before do
    allow(Rails.application.credentials).to receive(:aws).and_return(aws_credentials_mock)
  end

  it { expect(animal.reload.name).to eq(name) }
  it { expect(animal.reload.dob).to eq(dob) }
end