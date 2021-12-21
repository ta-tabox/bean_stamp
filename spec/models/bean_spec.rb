require 'rails_helper'

RSpec.describe Bean, type: :model do
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

  # roaster_id, name, country, bean_images, taste_tagsがあれば有効な状態であること
  describe '#create' do
    it 'is valid with a roaster_id, name, country, bean_images, taste_tags' do
      bean = create(:bean)
      expect(bean).to be_valid
    end

    # アップロードできる画像数が制限以下であることを検証する
    # アップロードできる画像サイズが制限以下であることを検証する
    # 画像が1枚もなければ無効な状態であること
    # taste_tagsがなければ無効な状態であること
    # taste＿tagsが最大数以上なら無効な状態であること
    # taste_tagsが重複していたら無効な状態であること
    # update_bean_imagesのテストってどうすればよい？画像が2枚登録されている状態で新しい画像を登録し、枚数が1枚になっていることを確認する
  end
end
