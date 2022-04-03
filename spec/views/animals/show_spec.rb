require 'rails_helper'

RSpec.describe '/animals/show', type: :view do
  let(:animal) { create(:animal_with_photos) }

  xit 'displays animals name' do
    assign :animal, animal

    render

    expect(rendered).to have_content(animal.name)
  end
end
