require 'aws/s3'

class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[show edit update destroy]

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
    # send the animal object and params to update services for photos and breeds
    # TODO: - safe params for nested photo attributes
    # TODO: - safe params for nested breed attributes
    PhotosService.new(@animal, params).add_photos
    BreedsService.new(@animal, params).save_breeds

    # fields on the animal object updated in the standard way
    if @animal.update(animal_params)
      redirect_to animal_url(@animal), notice: 'Animal was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /animals/1 or /animals/1.json
  def destroy
    PhotosService.new(@animal).delete_photos

    @animal.destroy
    redirect_to animals_url, notice: 'Animal was successfully destroyed.'
  end

  def delete_photo
    animal_id = params[:animal_id].to_i
    @animal = Animal.find(animal_id)

    PhotosService.new(@animal, params).delete_photo

    # redirect_to @animal
    redirect_to edit_animal_path(@animal)
  end

  def search
    @animals = SearchService.new(search_params).results
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

  def search_params
    params.permit(:size, :name, :sex)
  end
end
