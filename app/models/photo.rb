class Photo < ApplicationRecord
  belongs_to :animal

  validates :address, presence: true
end
