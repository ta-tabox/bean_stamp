require 'rails_helper'

RSpec.describe RoasterRelationship, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:roaster) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :follower_id }
    it { is_expected.to validate_presence_of :roaster_id }
  end
end
