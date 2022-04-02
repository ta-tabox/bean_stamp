require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:offer) }
    it { is_expected.to have_one(:bean).through(:offer) }
    it { is_expected.to have_one(:roaster).through(:offer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :offer_id }
  end

  describe '.search_status' do
    let(:user) { create(:user) }
    let(:bean) { create(:bean, :with_image, :with_3_taste_tags) }
    let(:offering_offer) { create(:offer, bean: bean) }
    let(:roasting_offer) { create(:offer, :on_roasting, bean: bean) }
    let(:preparing_offer) { create(:offer, :on_preparing, bean: bean) }
    let(:selling_offer) { create(:offer, :on_selling, bean: bean) }
    let(:sold_offer) { create(:offer, :end_of_sales, bean: bean) }

    subject { user.likes.search_status(status).take }

    before do
      user.like_offers.push(offering_offer, roasting_offer, preparing_offer, selling_offer, sold_offer)
    end

    context 'when search status is on_offering' do
      let(:status) { 'on_offering' }
      it 'returns a offering offer' do
        expect(subject.offer.status).to eq 'on_offering'
      end
    end
    context 'when search status is on_roasting' do
      let(:status) { 'on_roasting' }
      it 'returns a roasting offer' do
        expect(subject.offer.status).to eq 'on_roasting'
      end
    end
    context 'when search status is on_preparing' do
      let(:status) { 'on_preparing' }
      it 'returns a preparing offer' do
        expect(subject.offer.status).to eq 'on_preparing'
      end
    end
    context 'when search status is on_selling' do
      let(:status) { 'on_selling' }
      it 'returns a selling offer' do
        expect(subject.offer.status).to eq 'on_selling'
      end
    end
    context 'when search status is end_of_sales' do
      let(:status) { 'end_of_sales' }
      it 'returns a sold offer' do
        expect(subject.offer.status).to eq 'end_of_sales'
      end
    end
  end
end
