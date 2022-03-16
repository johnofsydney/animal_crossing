class BreedsService
  attr_reader :animal, :params

  def initialize(animal, params)
    @animal = animal
    @params = params
  end

  # if breed information is provided in the params, this method
  # will write those params as the breeds into the animal object.
  # any existing breeds will be overwritten
  def save_breeds
    return if params[:breeds].blank?

    breed_ids = params[:breeds][:ids].select(&:present?).map(&:to_i)
    return if breed_ids.blank?

    breeds = breed_ids.map { |id| Breed.find(id) }
    @animal.breeds = breeds
    @animal.save
  end
end

# TODO: write a test for this class
