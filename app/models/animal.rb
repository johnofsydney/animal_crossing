class Animal < ApplicationRecord
  enum size: { small: "small", medium: "medium", large: "large" }
  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :breeds
  accepts_nested_attributes_for :photos
end
