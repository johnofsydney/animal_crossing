# == Schema Information
#
# Table name: photos
#
#  id         :bigint           not null, primary key
#  address    :string
#  animal_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Photo < ApplicationRecord
  belongs_to :animal

  validates :address, presence: true
end
