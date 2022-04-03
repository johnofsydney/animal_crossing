# == Schema Information
#
# Table name: breeds
#
#  id         :bigint           not null, primary key
#  breed      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Breed < ApplicationRecord
  has_and_belongs_to_many :animals # rubocop:disable Rails/HasAndBelongsToMany
end
