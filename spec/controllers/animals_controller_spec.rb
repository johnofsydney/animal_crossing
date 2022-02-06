require 'rails_helper'

RSpec.describe AnimalsController, type: :controller do
  let(:breed) { Breed.create(breed: 'Cavoodle') }

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
    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:put_object)
    end

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    let(:animal) do
      Animal.create(name: 'John')
    end

    let(:params) do
      {
        id: animal.id,
        animal: {
          name: 'duncan',
          photos: [photo]
        },
        breeds: {
          ids: [breed.id]
        }
      }
    end

    let(:photo) do
      fixture_file_upload('SpongeBob.svg.png', 'image/png')
    end

    it 'updates a record' do
      put :update, params: params
      expect(assigns[:animal].name).to eq('duncan')
    end

    it 'puts an object into S3' do
      put :update, params: params

      expect(mock_s3_client).to have_received(:put_object)
    end

    it 'save the photo address on the photo for the animal' do
      put :update, params: params

      expect(animal.reload.photos.first.address).to match('amazonaws.com/photo')
    end
  end

  describe '#destroy' do
    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:delete_object)
    end

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    let!(:animal) do
      Animal.create(
        name: 'John',
        photos: [
          Photo.create(address: 's3bucketaddress')
        ]
      )
    end

    it 'destroy a record' do
      delete :destroy, params: { id: animal.id }
      expect(Animal.count).to eq(0)
    end

    it 'sends a delete request to S3' do
      delete :destroy, params: { id: animal.id }
      expect(mock_s3_client).to have_received(:delete_object)
    end
  end

  describe '#delete_photo' do
    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:delete_object)
    end

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    let!(:animal) do
      Animal.create(
        name: 'John',
        photos: [
          photo
        ]
      )
    end
    let(:photo) { Photo.create(address: 's3bucketaddress') }

    it 'destroy a record', :aggregate_failures do
      delete :delete_photo, params: { animal_id: animal.id, photo_id: photo.id }
      expect(Animal.count).to eq(1) # Animal is not deleted
      expect(Photo.count).to eq(0) # Photo is deleted
    end

    it 'sends a delete request to S3' do
      delete :delete_photo, params: { animal_id: animal.id, photo_id: photo.id }
      expect(mock_s3_client).to have_received(:delete_object)
    end
  end
end
