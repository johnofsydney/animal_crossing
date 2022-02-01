require 'rails_helper'

RSpec.describe AnimalsController, type: :controller do
  describe '#index' do
    before do
      animal_one
      animal_two
      animal_three
    end

    let(:animal_one) do
      Animal.create(
        name: 'foobar'
      )
    end

    let(:animal_two) do
      Animal.create(
        name: 'foobar'
      )
    end

    let(:animal_three) do
      Animal.create(
        name: 'foobar'
      )
    end

    it 'assigns the records' do
      get :index
      expect(assigns(:animals)).to eq([animal_one, animal_two, animal_three])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#show' do
    let(:animal_one) do
      Animal.create(
        name: 'foobar'
      )
    end

    it 'renders the template' do
      get :show, params: { id: animal_one.id }
      expect(response).to render_template('show')
    end

    it 'assigns the correct record' do
      get :show, params: { id: animal_one.id }

      expect(assigns(:animal)).to eq(animal_one)
    end
  end
end
