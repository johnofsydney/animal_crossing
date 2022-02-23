class AddAdopterToAnimal < ActiveRecord::Migration[7.0]
  def change
    add_column :animals, :adopted_by_name, :string
    add_column :animals, :adopted_by_email, :string
    add_column :animals, :adopted_by_phone, :string
    add_column :animals, :adopted_date, :date
  end
end
