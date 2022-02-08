require 'aws/s3'

class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[show edit update destroy]

  # rubocop:disable Metrics/AbcSize
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

    if @animal.save
      redirect_to animal_url(@animal), notice: 'Animal was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /animals/1 or /animals/1.json
  def update
    # TODO: - safe params for nested photo attributes
    AddPhotosService.new(@animal, params).process

    # TODO: - safe params for nested breed attributes
    WriteBreedsService.new(@animal, params).process

    breed_ids = params[:breeds][:ids].select(&:present?).map(&:to_i)
    if breed_ids.present?
      breeds = breed_ids.map { |id| Breed.find(id) }
      @animal.breeds = breeds
      @animal.save
    end

    if @animal.update(animal_params)
      redirect_to animal_url(@animal), notice: 'Animal was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /animals/1 or /animals/1.json
  def destroy
    # TODO: make a plural version: delete_objects

    s3_buckety = S3.new(photo_bucket)
    @animal.photos.each do |photo|
      key = photo.address.split('/').last

      s3_buckety.delete_object(
        key: key
      )
    end

    @animal.destroy
    redirect_to animals_url, notice: 'Animal was successfully destroyed.'
  end

  def delete_photo
    s3_buckety = S3.new(photo_bucket)

    animal_id = params[:animal_id].to_i
    photo_id = params[:photo_id].to_i

    @animal = Animal.find(animal_id)
    photo = Photo.find(photo_id)

    # 1 delete object from bucket
    key = photo.address.split('/').last

    s3_buckety.delete_object(
      key: key
    )

    # 2 destroy rails record
    @animal.photos.destroy(photo)

    # redirect_to @animal
    redirect_to edit_animal_path(@animal)
  end

  def search
    @animals = Animal.all
    return @animals if safe_params.values.all?(&:empty?)

    size = safe_params[:size]
    name = safe_params[:name]

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

  # def animal_name
  #   @animal.name || animal_params[:name] || ''
  # end

  def photo_bucket
    'doolittle-a1'
  end
  # rubocop:enable Metrics/AbcSize
end
