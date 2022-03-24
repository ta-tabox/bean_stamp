require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:bean) }
    it { is_expected.to have_many(:wants) }
    it { is_expected.to have_many(:wanted_users).through(:wants) }
    it { is_expected.to have_one(:roaster).through(:bean) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:liked_users).through(:likes) }
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

  describe '#update_status' do
    # upsate_statusでステータスを更新する
    before { test_offer.update_status }
    let(:bean) { create(:bean, :with_image, :with_3_taste_tags) }
    # 本日でオファー終わり
    let!(:offering_offer) { create(:offer, ended_at: Date.current, bean: bean) }
    # 本日までロースト中
    let!(:roasting_offer) { create(:offer, :on_roasting, roasted_at: Date.current, bean: bean) }
    # 本日まで準備中、明日から受付開始
    let!(:preparing_offer) { create(:offer, :on_preparing, receipt_started_at: Date.current.next_day(1), bean: bean) }
    # 本日から受付開始
    let!(:start_selling_offer) { create(:offer, :on_selling, receipt_started_at: Date.current, bean: bean) }
    # 本日まで受付中
    let!(:selling_offer) { create(:offer, :on_selling, receipt_ended_at: Date.current, bean: bean) }
    # 昨日まで受付中、本日は受付終了
    let!(:sold_offer) { create(:offer, :end_of_sales, receipt_ended_at: Date.current.prev_day(1), bean: bean) }

    # 境界値のテスト
    context "when an offer's ended_at is today" do
      let(:test_offer) { offering_offer }
      it { expect(test_offer.status).to eq 'on_offering' }
    end
    context "when an offer's roasted_at is today" do
      let(:test_offer) { roasting_offer }
      it { expect(test_offer.status).to eq 'on_roasting' }
    end
    context "when an offer's receipt_started_at is tomorrow" do
      let(:test_offer) { preparing_offer }
      it { expect(test_offer.status).to eq 'on_preparing' }
    end
    context "when an offer's receipt_started_at is today" do
      let(:test_offer) { start_selling_offer }
      it { expect(test_offer.status).to eq 'on_selling' }
    end
    context "when an offer's receipt_ended_at is today" do
      let(:test_offer) { selling_offer }
      it { expect(test_offer.status).to eq 'on_selling' }
    end
    context "when an offer's receipt_ended_at is yesterday" do
      let(:test_offer) { sold_offer }
      it { expect(test_offer.status).to eq 'end_of_sales' }
    end
  end

  # 検索で使用するスコープのテスト
  describe '#search_status' do
    let(:user) { create(:user, :with_roaster) }
    let(:bean) { create(:bean, :with_image, :with_3_taste_tags) }
    let!(:offering_offer) { create(:offer, roaster: user.roaster, bean: bean) }
    let!(:roasting_offer) { create(:offer, :on_roasting, roaster: user.roaster, bean: bean) }
    let!(:preparing_offer) { create(:offer, :on_preparing, roaster: user.roaster, bean: bean) }
    let!(:selling_offer) { create(:offer, :on_selling, roaster: user.roaster, bean: bean) }
    let!(:sold_offer) { create(:offer, :end_of_sales, roaster: user.roaster, bean: bean) }

    subject { user.roaster.offers.search_status(status).take }

    context 'when search status is on_offering' do
      let(:status) { 'on_offering' }
      it 'returns a offering offer' do
        expect(subject.status).to eq 'on_offering'
      end
    end
    context 'when search status is on_roasting' do
      let(:status) { 'on_roasting' }
      it 'returns a roasting offer' do
        expect(subject.status).to eq 'on_roasting'
      end
    end
    context 'when search status is on_preparing' do
      let(:status) { 'on_preparing' }
      it 'returns a preparing offer' do
        expect(subject.status).to eq 'on_preparing'
      end
    end
    context 'when search status is on_selling' do
      let(:status) { 'on_selling' }
      it 'returns a selling offer' do
        expect(subject.status).to eq 'on_selling'
      end
    end
    context 'when search status is end_of_sales' do
      let(:status) { 'end_of_sales' }
      it 'returns a sold offer' do
        expect(subject.status).to eq 'end_of_sales'
      end
    end
  end
end
