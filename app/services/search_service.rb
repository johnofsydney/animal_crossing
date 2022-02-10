class SearchService
  attr_reader :search_params

  def initialize(search_params)
    @search_params = search_params
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  def results
    @animals = Animal.all
    return @animals if search_params.values.all?(&:empty?)

    size = search_params[:size]
    sex = search_params[:sex]
    age_group = search_params[:age_group]
    name = search_params[:name]

    @animals = @animals.where(size: size) if size.present?
    @animals = @animals.where(sex: sex) if sex.present?
    @animals = @animals.select { |a| a.age_group == age_group } if age_group.present?
    @animals = @animals.where('name ILIKE :name OR description ILIKE :name', name: "%#{name}%") if name.present?

    @animals
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
end

# TODO: write a test for this class
