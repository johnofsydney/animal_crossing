class AddAnimalFlags < ActiveRecord::Migration[7.0]
  def change
    add_column :animals, :good_with_small_children, :boolean
    add_column :animals, :good_with_older_children, :boolean
    add_column :animals, :good_with_other_dogs, :boolean
    add_column :animals, :good_with_cats, :boolean
    add_column :animals, :can_be_left_alone_during_working_hours, :boolean
    add_column :animals, :apartment_friendly, :boolean
  end
end
