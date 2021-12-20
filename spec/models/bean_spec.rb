require 'rails_helper'

RSpec.describe Bean, type: :model, focus: true do
  # name, phone_number, prefecture_code, addressがあれば有効な状態であること
  # roaste_id, roaster, image, tasteの登録を行う必要がある
  skip 'is valid with a roaster_id, name, country' do
    bean = build(:bean)
    expect(bean).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:roaster) }
    it { is_expected.to belong_to(:roast_level).class_name('MstRoastLevel') }
    it { is_expected.to have_many(:bean_images).dependent(:destroy) }
    it { is_expected.to have_many(:bean_taste_tags).dependent(:destroy) }
    it { is_expected.to have_many(:taste_tags).through(:bean_taste_tags).source(:mst_taste_tag) }
    it { is_expected.to accept_nested_attributes_for(:bean_taste_tags).allow_destroy(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :roaster_id }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_length_of(:describe).is_at_most(300) }
    it { is_expected.to validate_inclusion_of(:acidity).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:flavor).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:body).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:bitterness).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:sweetness).in_range(1..5) }
  end
end
