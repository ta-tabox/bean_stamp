require 'rails_helper'

RSpec.describe RoasterRelationship, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:roaster) }
  end
end
