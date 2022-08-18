require 'rails_helper'

RSpec.describe MstCountry, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:beans).with_foreign_key('country_id').inverse_of(:country) }
  end
end
