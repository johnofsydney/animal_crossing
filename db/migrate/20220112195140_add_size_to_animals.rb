class AddSizeToAnimals < ActiveRecord::Migration[7.0]
  def change
    add_column :animals, :size, :string
  end
end
