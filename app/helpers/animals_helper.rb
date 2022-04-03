# rubocop:disable Rails/HelperInstanceVariable
module AnimalsHelper
  def can_show_adoption_details?
    current_user.present? && @animal.adopted?
  end

  def page_title
    @animal.adopted? ? adopted_message : animal_name
  end

  def adopted_message
    "#{animal_name} has been adopted."
  end

  def animal_name
    @animal.name.capitalize
  end
end
# rubocop:enable Rails/HelperInstanceVariable
