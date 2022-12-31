require 'rails_helper'

RSpec.describe AnimalsController do
  let(:user) { create(:user) }
  let(:animal) { create(:animal) }

  describe '#index' do
    it 'redirects to the root path' do
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    it 'renders the template' do
      get :show, params: { id: animal.id }
      expect(response).to render_template('show')
    end

    it 'assigns the correct record' do
      get :show, params: { id: animal.id }

      expect(assigns(:animal)).to eq(animal)
    end
  end

  describe '#create' do
    let(:valid_animal_params) do
      {
        name: 'duncan',
        dob: Date.new(2021, 12, 25),
        description: 'is a good boy',
        size: 'small',
        sex: 'male',
        species: 'dog'
      }
    end

    context 'when the user is not logged in' do
      before do
        post :create, params: { animal: valid_animal_params }
      end

      it 'does not create a new record' do
        expect(Animal.count).to eq(0)
      end
    end

    context 'when the user is logged in' do
      before do
        sign_in user

        post :create, params: { animal: valid_animal_params }
      end

      it 'creates a new record' do
        expect(Animal.count).to eq(1)
      end

      it 'has the correct data' do
        animal = Animal.last
        expect(animal.attributes.with_indifferent_access).to match(hash_including(valid_animal_params))
      end
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

    let(:breed) { Breed.create(breed: 'tim tam') }

    let(:params) do
      {
        id: animal.id,
        animal: {
          name: animal_name,
          photos: [image_file]
        },
        breeds: {
          ids: [breed.id]
        }
      }
    end
    let(:animal_name) { 'Rosko' }

    let(:image_file) do
      # this is not an instance of Photo
      fixture_file_upload('SpongeBob.svg.png', 'image/png')
    end

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'updates a record' do
        put :update, params: params
        expect(assigns[:animal].name).to eq(animal_name)
      end

      it 'puts an object into S3' do
        put :update, params: params

        expect(mock_s3_client).to have_received(:put_object)
      end

      it 'save the photo address on the photo for the animal', :aggregate_failures do
        put :update, params: params

        expect(animal.reload.photos.first.address).to match('amazonaws.com/photo')
        expect(animal.reload.photos.first.address).to match(animal_name)
      end
    end
  end

  describe '#destroy' do
    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:delete_object)
    end

    let(:photo) { create(:photo) }
    let(:animal) { photo.animal }

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    context 'when the user is logged in' do
      before do
        sign_in user
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
  end

  describe '#delete_photo' do
    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:delete_object)
    end

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    let(:photo) { create(:photo) }
    let(:animal) { photo.animal }

    let(:expected_key) { photo.address.split('/').last }

    it 'destroy a record', :aggregate_failures do
      delete :delete_photo, params: { animal_id: animal.id, photo_id: photo.id }
      expect(Animal.count).to eq(1) # Animal is not deleted
      expect(Photo.count).to eq(0) # Photo is deleted
    end

    it 'sends a delete request to S3' do
      delete :delete_photo, params: { animal_id: animal.id, photo_id: photo.id }
      expect(mock_s3_client)
        .to have_received(:delete_object)
        .with(hash_including(key: expected_key))
    end
  end
end
