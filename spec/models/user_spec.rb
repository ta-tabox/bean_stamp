require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:roaster).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe '#create' do
    # name, email, passwordがあれば有効な状態であること
    it 'is valid with a name, email and password' do
      user = build(:user)
      expect(user).to be_valid
    end

    # 画像登録ができるテストを記述する
  end

  describe 'belonged_roaster?(roaster)' do
    let(:user) { create(:user, roaster: belonged_roaster) }
    let(:belonged_roaster) { create(:roaster, name: 'belongd_roaster') }
    let(:another_roaster) { create(:roaster, name: 'another_roaster') }

    it 'return true if user belong to roaster' do
      expect(user.belonged_roaster?(belonged_roaster)).to be true
    end

    it 'return false if user not belong to roaster' do
      expect(user.belonged_roaster?(another_roaster)).to be false
    end
  end

  describe 'had_bean?(bean)' do
    let(:user) { create(:user, roaster: belonged_roaster) }
    let(:belonged_roaster) { create(:roaster, name: 'belongd_roaster') }
    let(:another_roaster) { create(:roaster, name: 'another_roaster') }
    let(:my_bean) { create(:bean, :with_image, :with_taste_3tags, roaster: belonged_roaster) }
    let(:another_bean) { create(:bean, :with_image, :with_taste_3tags, roaster: another_roaster) }

    it 'return true if user have the bean' do
      expect(user.had_bean?(my_bean)).to be true
    end

    it 'return false if user not have the bean' do
      expect(user.had_bean?(another_bean)).to be false
    end
  end
end
