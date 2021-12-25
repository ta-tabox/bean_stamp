require 'rails_helper'

RSpec.describe Roaster, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:nullify) }
    it { is_expected.to have_many(:beans).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :phone_number }
    it { is_expected.to validate_numericality_of(:phone_number).only_integer }
    it { is_expected.to validate_length_of(:phone_number).is_at_least(10).is_at_most(11) }
    it { is_expected.to validate_presence_of :prefecture_code }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_length_of(:describe).is_at_most(300) }
  end

  describe '#create', focus: true do
    let(:roaster) { build(:roaster) }
    let(:roaster_with_image) { create(:roaster, :with_image) }
    # name, phone_number, prefecture_code, addressがあれば有効な状態であること
    it 'is valid with a name, phone_number, prefecture_code and address' do
      expect(roaster).to be_valid
    end

    # 画像登録ができる
    it 'attach a image to roaster' do
      expect(roaster_with_image.image?).to be true
    end
  end
end
