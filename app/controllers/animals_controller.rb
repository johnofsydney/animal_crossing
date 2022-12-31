require 'aws/s3'

class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    # no one needs to see the list of all animals ever
    redirect_to root_path # and return nil
  end

  def show
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

      redirect_to animal_url(@animal)
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
      redirect_to animal_url(@animal)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    PhotosService.new(@animal).delete_photos

    @animal.destroy
    redirect_to animals_url, notice: 'Animal record was successfully deleted.'
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
    @title = 'Dogs available for adoption'
    render :index
  end

  def cats
    @animals = Animal.not_adopted.cat
    @title = 'Cats available for adoption'
    render :index
  end

  def others
    @animals = Animal.not_adopted.other
    @title = 'Other animals available for adoption'
    render :index
  end

  def adopted
    @animals = Animal.adopted
    @title = 'Animals already adopted'
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
