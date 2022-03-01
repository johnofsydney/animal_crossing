require 'rails_helper'

RSpec.describe "/animals/index", type: :view do
  let(:animals) { [create(:animal_with_photos)] }

  it "displays title" do
    assign :animals, animals

    render

    expect(rendered).to have_css("h1", text: "Animals")
  end

  it "displays animals name" do
    assign :animals, [create(:animal_with_photos)]

    render

    expect(rendered).to have_content(animals.last.name)
  end
end