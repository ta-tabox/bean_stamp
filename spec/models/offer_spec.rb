require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:bean) }
    pending { is_expected.to have_many(:likes) }
    pending { is_expected.to have_many(:wants) }
    pending { is_expected.to have_many(:comments) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :bean_id }
    it { is_expected.to validate_presence_of :ended_at }
    it { is_expected.to validate_presence_of :roasted_at }
    it { is_expected.to validate_presence_of :receipt_started_at }
    it { is_expected.to validate_presence_of :receipt_ended_at }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_numericality_of(:price).only_integer }
    it { is_expected.to validate_presence_of :weight }
    it { is_expected.to validate_numericality_of(:weight).only_integer }
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_numericality_of(:amount).only_integer }
  end
end
