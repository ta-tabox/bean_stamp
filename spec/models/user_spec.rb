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
end
