class SearchService
  attr_reader :search_params

  def initialize(search_params)
    @search_params = search_params
  end

  def results
    @animals = Animal.all
    return @animals if search_params.values.all?(&:empty?)

    size = search_params[:size]
    name = search_params[:name]

    @animals = @animals.where(size: size) if size.present?
    @animals = @animals.where('name ILIKE :name OR description ILIKE :name', name: "%#{name}%") if name.present?
  end
end
