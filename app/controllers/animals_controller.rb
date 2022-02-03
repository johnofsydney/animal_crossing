require 'aws/s3'
# require 'aws/S4'
class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[show edit update destroy]

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # GET /animals or /animals.json
  def index
    @animals = Animal.all
  end

  # GET /animals/1 or /animals/1.json
  def show
    @animal
  end

  # GET /animals/new
  def new
    @animal = Animal.new
  end

  # GET /animals/1/edit
  def edit; end

  # POST /animals or /animals.json
  def create
    @animal = Animal.new(animal_params)

    redirect_to animal_url(@animal), notice: 'Animal was successfully created.' if @animal.save
  end

  # PATCH/PUT /animals/1 or /animals/1.json
  def update
    # TODO: S3 refactors
    # - permissions for S3 bucket are too lax
    # - make a plural version: put_objects

    # TODO: - safe params for nested photo attributes
    images = params['animal']['photos'].select(&:present?)

    if images.present?
      images.each do |image|
        file = image.tempfile
        key = "photo-#{Time.zone.today}-#{animal_name}-#{SecureRandom.hex(2)}"

        upload = S3.put_object(
          bucket: photo_bucket,
          key: key,
          body: file
        )

        photo = Photo.new(address: upload[:address])
        @animal.photos << photo
      end

      @animal.save
    end

    # TODO: - safe params for nested breed attributes
    breed_ids = params[:breeds][:ids].select(&:present?).map(&:to_i)
    if breed_ids.present?
      breeds = breed_ids.map { |id| Breed.find(id) }
      @animal.breeds = breeds
      @animal.save
    end

    redirect_to animal_url(@animal), notice: 'Animal was successfully updated.' if @animal.update(animal_params)
  end

  # DELETE /animals/1 or /animals/1.json
  def destroy
    # TODO: make a plural version: delete_objects
    @animal.photos.each do |photo|
      key = photo.address.split('/').last

      S3.delete_object(
        bucket: photo_bucket,
        key: key
      )
    end

    @animal.destroy

    respond_to do |format|
      format.html { redirect_to animals_url, notice: 'Animal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_photo
    animal_id = params[:animal_id].to_i
    photo_id = params[:photo_id].to_i

    @animal = Animal.find(animal_id)
    photo = Photo.find(photo_id)

    # 1 delete object from bucket
    key = photo.address.split('/').last

    S3.delete_object(
      bucket: photo_bucket,
      key: key
    )

    # 2 destroy rails record
    @animal.photos.destroy(photo)

    # redirect_to @animal
    redirect_to edit_animal_path(@animal)
  end

  def search; end

  def results
    size = safe_params[:size]
    name = safe_params[:name]

    @animals = Animal.all
    @animals = @animals.where(size: size) if size.present?
    @animals = @animals.where('name ILIKE :name OR description ILIKE :name', name: "%#{name}%") if name.present?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_animal
    @animal = Animal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def animal_params
    params.require(:animal).permit(:name, :dob, :description, :size)
  end

  def safe_params
    params.permit(:size, :name)
  end

  def animal_name
    @animal.name || animal_params[:name] || ''
  end

  def photo_bucket
    'doolittle-a1'
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
