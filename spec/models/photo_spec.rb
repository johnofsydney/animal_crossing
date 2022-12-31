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
require 'rails_helper'

RSpec.describe Photo do
  it { is_expected.to validate_presence_of(:address) }
end
