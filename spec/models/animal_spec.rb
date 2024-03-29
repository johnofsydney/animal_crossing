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
require 'rails_helper'

RSpec.describe Animal do
  subject(:animal) do
    build(
      :animal,
      dob: dob,
      photos: [photo]
    )
  end

  let(:dob) { Date.new(2022, 1, 20) }
  let(:photo) { create(:photo) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:size) }
  it { is_expected.to validate_presence_of(:sex) }
  it { is_expected.to validate_presence_of(:species) }

  it { is_expected.to have_many(:photos) }

  describe '#age and #age_group' do
    context 'when the animal is a puppy' do
      let(:dob) { Time.zone.today - 21 }

      it { expect(animal.age).to eq('3 weeks old') }
      it { expect(animal.age_group).to eq('puppy') }
    end

    context 'when the animal is an adult' do
      let(:dob) { Time.zone.today - 2000 }

      it { expect(animal.age).to eq('5 years old') }
      it { expect(animal.age_group).to eq('adult') }
    end

    context 'when the animal is very old', :aggregate_failures do
      let(:dob) { Time.zone.today - 6_000 }

      it { expect(animal.age).to eq('16 years old') }
      it { expect(animal.age_group).to eq('old') }
    end
  end
end
