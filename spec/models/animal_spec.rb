require 'rails_helper'

RSpec.describe Animal, type: :model do
  subject(:animal) do
    FactoryBot.build(
      :animal,
      dob: dob
    )
  end

  let(:dob) { Date.new(2022, 1, 20) }

  describe '#age and #age_group' do
    context 'when the animal is a puppy' do
      let(:dob) { Time.zone.today - 21 }

      it { expect(animal.age).to eq('3 weeks') }
      it { expect(animal.age_group).to eq('puppy') }
    end

    context 'when the animal is an adult' do
      let(:dob) { Time.zone.today - 2000 }

      it { expect(animal.age).to eq('5 years') }
      it { expect(animal.age_group).to eq('adult') }
    end

    context 'when the animal is very old', :aggregate_failures do
      let(:dob) { Time.zone.today - 6_000 }

      it { expect(animal.age).to eq('16 years') }
      it { expect(animal.age_group).to eq('old') }
    end
  end
end
