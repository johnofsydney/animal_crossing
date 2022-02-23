class AddSpeciesToAnimal < ActiveRecord::Migration[7.0]
  def change
    add_column :animals, :species, :string
  end
end
