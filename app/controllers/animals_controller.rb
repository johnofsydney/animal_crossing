require 'aws/s3'

class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[show edit update destroy]

  # GET /animals or /animals.json
  def index
    # save this for admin / logged in users
    @user = user?

    if user?
      @animals = Animal.all
    else
      @animals = Animal.not_adopted
    end

  end

  def show
    # TODO: fix this nonsense
    @user = user?
    @dogs_path = '/animals/dogs'
    # @cats_path = '/animals/cats'
    @animal
  end

  def new
    @animal = Animal.new
  end

  def edit; end

  def create
    @animal = Animal.new(animal_params)

    if @animal.save
      PhotosService.new(@animal, params).add_photos
      BreedsService.new(@animal, params).save_breeds

      redirect_to animal_url(@animal), notice: 'Animal was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @animal.update(animal_params)
      # send the animal object and params to update services for photos and breeds
      # TODO: - safe params for nested photo attributes
      # TODO: - safe params for nested breed attributes
      PhotosService.new(@animal, params).add_photos
      BreedsService.new(@animal, params).save_breeds
      redirect_to animal_url(@animal), notice: 'Animal was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    PhotosService.new(@animal).delete_photos

    @animal.destroy
    redirect_to animals_url, notice: 'Animal was successfully destroyed.'
  end

  def delete_photo
    animal_id = params[:animal_id].to_i
    @animal = Animal.find(animal_id)

    PhotosService.new(@animal, params).delete_photo

    redirect_to edit_animal_path(@animal)
  end

  # def search
  #   @animals = SearchService.new(search_params).results
  # end
  def dogs
    @animals = Animal.not_adopted.dog
    @title = "Dogs available for adoption"
    render :index
  end

  def cats
    @animals = Animal.not_adopted.cat
    @title = "Cats available for adoption"
    render :index
  end

  def others
    @animals = Animal.not_adopted.other
    @title = "Other animals available for adoption"
    render :index
  end

  def adopted
    @animals = Animal.adopted
    @title = "Animals already adopted"
    render :index
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_animal
    @animal = Animal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def animal_params
    params.require(:animal).permit(:name, :dob, :description, :size, :sex, :species)
  end

  # def search_params
  #   params.permit(
  #     :size,
  #     :name,
  #     :sex,
  #     :species,
  #     :age_group,
  #     :good_with_small_children,
  #     :good_with_older_children,
  #     :good_with_other_dogs,
  #     :good_with_cats,
  #     :can_be_left_alone_during_working_hours,
  #     :apartment_friendly
  #   )
  # end
end
