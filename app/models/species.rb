class Species < ApplicationRecord
  has_many :breeds, dependent: :destroy
  has_many :animals, through: :breeds
end
