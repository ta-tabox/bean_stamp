require 'rails_helper'

RSpec.describe MstRoastLevel, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:beans).with_foreign_key('roast_level_id').inverse_of(:roast_level) }
  end
end
