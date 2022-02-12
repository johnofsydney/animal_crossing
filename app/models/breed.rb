class Breed < ApplicationRecord
  has_and_belongs_to_many :animals # rubocop:disable Rails/ HasAndBelongsToMany

  belongs_to :species
end
