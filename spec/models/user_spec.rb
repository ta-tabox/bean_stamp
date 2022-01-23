require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:roaster).optional }
    it { is_expected.to have_many(:roaster_relationships).with_foreign_key('follower_id').inverse_of(:follower).dependent(:destroy) }
    it { is_expected.to have_many(:following_roasters).through(:roaster_relationships) }
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

  # roasterのfollow関係のテスト
  describe 'follow_roaster_function', focus: true do
    let(:user) { create(:user) }
    let(:roaster) { create(:roaster) }

    describe '#following_roaster' do
      subject { user.following_roaster?(roaster) }
      context 'when user does not follow a roaster' do
        it { is_expected.to be_falsey }
      end
      context 'when user is following a roaster' do
        before { user.following_roasters << roaster }
        it { is_expected.to be_truthy }
      end
    end

    describe '#follow_roaster' do
      subject { proc { user.follow_roaster(roaster) } }
      it { is_expected.to change(RoasterRelationship, :count).by(1) }
      it { is_expected.to change(user.following_roasters, :count).by(1) }
      it { is_expected.to change(roaster.followers, :count).by(1) }
    end

    describe '#unfollow_roaster' do
      subject { proc { user.unfollow_roaster(roaster) } }
      before { user.following_roasters << roaster }
      it { is_expected.to change(RoasterRelationship, :count).by(-1) }
      it { is_expected.to change(user.following_roasters, :count).by(-1) }
      it { is_expected.to change(roaster.followers, :count).by(-1) }
    end
  end
end
