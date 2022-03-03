require 'rails_helper'

RSpec.describe Photo, type: :model do
  it { is_expected.to validate_presence_of(:address) }
end
