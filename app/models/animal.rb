class Animal < ApplicationRecord
  enum size: { small: 'small', medium: 'medium', large: 'large' }
  enum sex: { male: 'male', female: 'female' }

  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :breeds # rubocop:disable Rails/HasAndBelongsToMany

  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :breeds
end
