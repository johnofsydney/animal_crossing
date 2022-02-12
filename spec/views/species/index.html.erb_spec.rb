require 'rails_helper'

RSpec.describe "species/index", type: :view do
  before(:each) do
    assign(:species, [
      Species.create!(
        name: "Name"
      ),
      Species.create!(
        name: "Name"
      )
    ])
  end

  xit "renders a list of species" do
    render
    assert_select "strong", text: "Name".to_s, count: 2
  end
end
