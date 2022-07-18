require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:roaster).optional }
    it { is_expected.to have_many(:roaster_relationships).with_foreign_key('follower_id').inverse_of(:follower).dependent(:destroy) }
    it { is_expected.to have_many(:following_roasters).through(:roaster_relationships) }
    it { is_expected.to have_many(:wants) }
    it { is_expected.to have_many(:want_offers).through(:wants) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to have_many(:like_offers).through(:likes) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe '#create' do
    let(:user) { build(:user) }
    let(:user_with_image) { create(:user, :with_image) }
    # name, email, passwordがあれば有効な状態であること
    it 'is valid with a name, email and password' do
      expect(user).to be_valid
    end

    # 画像登録ができること
    context 'when user with image' do
      it 'attach a image to user' do
        expect(user_with_image).to be_image
      end
    end
  end

  describe '#belonged_roaster?' do
    subject { user.belonged_roaster?(roaster) }
    let(:roaster) { create(:roaster) }

    context 'when user belongs_to the roaster' do
      let(:user) { create(:user, roaster: roaster) }
      it { is_expected.to be_truthy }
    end

    context 'when user does not belongs_to the roaster' do
      let(:user) { create(:user) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#had_bean?' do
    subject { user.had_bean?(bean) }
    let(:roaster) { create(:roaster) }
    let(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }

    context 'when user belongs_to the roaster' do
      let(:user) { create(:user, roaster: roaster) }
      it { is_expected.to be_truthy }
    end

    context 'when user does not belongs_to the roaster' do
      let(:user) { create(:user) }
      it { is_expected.to be_falsey }
    end
  end

  # ユーザーの好みのtaste_groupのid一覧を返すメソッド
  describe '#favorite_taste_group_ids' do
    subject { user.favorite_taste_group_ids(ids_count) }
    let(:user) { create(:user) }
    let(:floral_offer) { create(:offer, bean: floral_bean) }
    let(:berry_offer) { create(:offer, bean: berry_bean) }
    let(:fruit_offer) { create(:offer, bean: fruit_bean) }
    let(:floral_bean) { create(:bean, :with_image, :with_floral_tags) }
    let(:berry_bean) { create(:bean, :with_image, :with_berry_tags) }
    let(:fruit_bean) { create(:bean, :with_image, :with_fruit_tags) }

    before do
      user.want_offers.push(floral_offer, berry_offer, fruit_offer)
      user.wants.each { |want| want.update(receipted_at: Date.current) }
      user.wants.find_by(offer_id: floral_offer.id).excellent! # taste_group_id = 1
      user.wants.find_by(offer_id: berry_offer.id).good! # taste_group_id = 6
      user.wants.find_by(offer_id: fruit_offer.id).so_so! # taste_group_id = 14
    end
    context 'when argument is 2 ids count' do
      let(:ids_count) { 2 }

      it 'returns 2 high rated taste_group ids' do
        expect(subject).to eq [1, 6]
      end
    end
  end
end
