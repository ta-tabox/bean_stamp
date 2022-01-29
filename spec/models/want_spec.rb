require 'rails_helper'

RSpec.describe Want, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:offer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :offer_id }
  end
end
