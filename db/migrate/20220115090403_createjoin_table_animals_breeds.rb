class CreatejoinTableAnimalsBreeds < ActiveRecord::Migration[7.0]
  def change
    create_join_table :animals, :breeds do |t|
      # t.index [:animal_id, :breed_id]
      # t.index [:breed_id, :animal_id]
    end
  end
end
