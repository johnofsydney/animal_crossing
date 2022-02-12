class Animal < ApplicationRecord
  enum size: { small: 'small', medium: 'medium', large: 'large' }
  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :breeds # rubocop:disable Rails/HasAndBelongsToMany
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :breeds

  scope :adopted, -> { where.not(adopted_date: nil) }
  scope :not_adopted, -> { where(adopted_date: nil) }
end
