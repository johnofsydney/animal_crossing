class SearchService
  attr_reader :search_params

  def initialize(search_params)
    @search_params = search_params
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def results
    @animals = Animal.not_adopted
    return @animals if search_params.values.all?(&:empty?)

    @animals = @animals.where(size: size) if size.present?
    @animals = @animals.where(sex: sex) if sex.present?
    @animals = @animals.where(species: species) if species.present?
    @animals = @animals.select { |a| a.age_group == age_group } if age_group.present?
    @animals = @animals.where('name ILIKE :name OR description ILIKE :name', name: "%#{name}%") if name.present?

    @animals = @animals.where(good_with_small_children: good_with_small_children) if good_with_small_children
    @animals = @animals.where(good_with_older_children: good_with_older_children) if good_with_older_children
    @animals = @animals.where(good_with_other_dogs: good_with_other_dogs) if good_with_other_dogs
    @animals = @animals.where(good_with_cats: good_with_cats) if good_with_cats
    @animals = @animals.where(can_be_left_alone_during_working_hours: can_be_left_alone_during_working_hours) if can_be_left_alone_during_working_hours
    @animals = @animals.where(apartment_friendly: apartment_friendly) if apartment_friendly

    @animals
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  private

  def size
    @size ||= search_params[:size]
  end

  def sex
    @sex ||= search_params[:sex]
  end

  def species
    @species ||= search_params[:species]
  end

  def age_group
    @age_group ||= search_params[:age_group]
  end

  def name
    @name ||= search_params[:name]
  end

  def good_with_small_children
    @good_with_small_children ||= to_bool(search_params[:good_with_small_children])
  end

  def good_with_older_children
    @good_with_older_children ||= to_bool(search_params[:good_with_older_children])
  end

  def good_with_other_dogs
    @good_with_other_dogs ||= to_bool(search_params[:good_with_other_dogs])
  end

  def good_with_cats
    @good_with_cats ||= to_bool(search_params[:good_with_cats])
  end

  def can_be_left_alone_during_working_hours
    @can_be_left_alone_during_working_hours ||= to_bool(search_params[:can_be_left_alone_during_working_hours])
  end

  def apartment_friendly
    @apartment_friendly ||= to_bool(search_params[:apartment_friendly])
  end

  def to_bool(value)
    # check boxes on a form are "1" or "0"
    return true if value.to_i == 1
    return false if value.to_i.zero?
  end
end

# TODO: scrap this all in favour of JS filter on FE
