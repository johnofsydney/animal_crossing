class Animal < ApplicationRecord
  enum size: { small: "small", medium: "medium", large: "large" }
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos
end
