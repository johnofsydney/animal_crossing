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

  describe '#create' do
    it 'creates a new record' do
      post :create, params: { animal: { name: 'duncan' } }
      expect(assigns[:animal]).to eq(Animal.first)
    end
  end

  describe '#update' do
    let!(:animal) do
      Animal.create(name: 'John')
    end

    it 'updates a record' do
      post :create, params: { animal: { id: animal.id, name: 'duncan' } }
      expect(assigns[:animal].name).to eq('duncan')
    end
  end

  describe '#destroy' do
    let!(:animal) do
      Animal.create(name: 'John')
    end

    it 'destroy a record' do
      delete :destroy, params: { id: animal.id }
      expect(Animal.count).to eq(0)
    end
  end
end