require 'rails_helper'

RSpec.describe '/animals/index' do
  let(:animals) { [create(:animal_with_photos)] }

  it 'displays title' do
    assign :animals, animals
    assign :title, 'Animals'

    render

    expect(rendered).to have_css('h1', text: 'Animals')
  end

  it 'displays animals name' do
    assign :animals, animals

    render

    expect(rendered).to have_content(animals.first.name)
  end
end
