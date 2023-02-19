require 'rails_helper'

RSpec.describe Bean, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:roaster) }
    it { is_expected.to belong_to(:roast_level).class_name('MstRoastLevel') }
    it { is_expected.to belong_to(:country).class_name('MstCountry') }
    it { is_expected.to have_many(:bean_images).dependent(:destroy) }
    it { is_expected.to have_many(:bean_taste_tags).dependent(:destroy) }
    it { is_expected.to have_many(:taste_tags).through(:bean_taste_tags).source(:mst_taste_tag) }
    it { is_expected.to accept_nested_attributes_for(:bean_taste_tags).allow_destroy(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :roaster_id }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :country_id }
    it { is_expected.to validate_length_of(:describe).is_at_most(300) }
    it { is_expected.to validate_inclusion_of(:acidity).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:flavor).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:body).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:bitterness).in_range(1..5) }
    it { is_expected.to validate_inclusion_of(:sweetness).in_range(1..5) }
  end

  describe 'custom validations' do
    let(:roaster) { create(:roaster) }
    let(:bean) { build(:bean) }
    subject { bean.valid? }

    # アップロードできる画像サイズが制限以下であることを検証する
    it 'is invalid with a too big size image' do
      bean.bean_images << build(:too_big_bean_image, bean: bean)
      subject
      expect(bean.errors[:bean_images]).to include('は不正な値です')
    end

    # アップロードできる画像数が制限以下であることを検証する
    it 'is invalid with too many upload images' do
      bean.upload_images = []
      # uploadする画像を5枚にする
      5.times do
        bean.upload_images << build(:bean_image, bean: bean)
      end
      subject
      expect(bean.errors[:bean_images]).to include('は4枚までしか登録できません')
    end

    # 画像が1枚もなければ無効な状態であること
    it 'is invalid with no images' do
      subject
      expect(bean.errors[:bean_images]).to include('は最低1枚登録してください')
    end

    # taste_tagsがなければ無効な状態であること
    it 'is invalid with no taste_tags' do
      subject
      expect(bean.errors[:taste_tags]).to include('は2つ以上登録してください')
    end

    # taste_tagsが最小値以下であれば無効な状態であること
    it 'is invalid with less then min counts of taste_tags' do
      bean.taste_tags << MstTasteTag.find(1)
      subject
      expect(bean.errors[:taste_tags]).to include('は2つ以上登録してください')
    end

    # taste＿tagsが最大数以上なら無効な状態であること
    it 'is invalid with too many taste_tags' do
      4.times do |n|
        bean.taste_tags << MstTasteTag.find(n + 1)
      end
      subject
      expect(bean.errors[:taste_tags]).to include('は最大3つまでしか登録できません')
    end

    # taste_tagsが重複していたら無効な状態であること
    it 'is invalid with duplication of taste_tags' do
      2.times do
        bean.taste_tags << MstTasteTag.find(1)
      end
      subject
      expect(bean.errors[:taste_tags]).to include('が重複しています')
    end
  end

  describe '#create' do
    # roaster_id, name, country, bean_images, taste_tagsがあれば有効な状態であること
    context 'when with three taste_tags' do
      let(:bean) { create(:bean, :with_image, :with_3_taste_tags) }
      it { expect(bean).to be_valid }
    end

    # taste_tagsが最小数以上、最大数以下であれば有効な状態であること
    context 'when with two taste_tags' do
      let(:bean) { create(:bean, :with_image, :with_2_taste_tags) }
      it { expect(bean).to be_valid }
    end
  end

  describe '#update' do
    let(:bean) { create(:bean, :with_image, :with_3_taste_tags) }
    context 'when with upload_images' do
      it 'is changed to the images for update' do
        bean.upload_images = []
        # uploadする画像を2枚にする
        2.times do
          bean.upload_images << build(:bean_image, bean: bean)
        end
        # updateによりbean.bean_imagesが1→2に変更される
        expect { bean.update_with_bean_images({}) }.to change(bean.bean_images, :count).from(1).to(2)
      end
    end

    context 'when with no upload_images' do
      it 'is not changed for image' do
        bean.upload_images = nil
        # updateによりbean.bean_imagesが変更されない
        expect { bean.update_with_bean_images({}) }.to_not change(bean.bean_images, :count)
      end
    end
  end
end
