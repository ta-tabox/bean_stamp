class Bean < ApplicationRecord
  MAX_UPLOAD_IMAGES_COUNT = 4
  MIN_TASTE_TAGS_COUNT = 2
  MAX_TASTE_TAGS_COUNT = 3
  attr_accessor :upload_images

  belongs_to :roaster
  has_many :bean_images, dependent: :destroy
  belongs_to :roast_level, class_name: 'MstRoastLevel'
  belongs_to :country, class_name: 'MstCountry'

  # bean_tagsのアソシエーション
  has_many :bean_taste_tags, dependent: :destroy
  has_many :taste_tags, through: :bean_taste_tags, source: :mst_taste_tag
  has_many :offers, dependent: :destroy
  accepts_nested_attributes_for :bean_taste_tags, allow_destroy: true

  scope :recent, -> { order(created_at: :desc) }
  validates :roaster_id, presence: true
  validates :name, presence: true
  validates :country_id, presence: true
  validates :describe, length: { maximum: 300 }
  with_options inclusion: { in: (1..5) } do
    validates :acidity
    validates :flavor
    validates :body
    validates :bitterness
    validates :sweetness
  end
  validate :bean_images_shuld_save_at_least_one
  validate :bean_country_should_be_select_anyone
  validate :upload_images_cannot_be_greater_than_max_upload_images_count
  validate :taste_tags_cannot_be_greater_than_max_taste_tags_count
  validate :taste_tags_cannot_be_less_than_min_taste_tags_count
  validate :taste_tags_cannot_be_duplicated

  def update_with_bean_images(bean_params)
    transaction do
      update!(bean_params)
      update_bean_images if upload_images
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  # アップロードする画像数がMAX_UPLOAD_IMAGES_COUNT以下であるか検証する
  def upload_images_cannot_be_greater_than_max_upload_images_count
    unless upload_images && upload_images.length > MAX_UPLOAD_IMAGES_COUNT
      return
    end

    errors.add(
      :bean_images,
      "は#{MAX_UPLOAD_IMAGES_COUNT}枚までしか登録できません",
    )
  end

  # 最低1枚以上の画像の登録を要求する
  # upload_images->POSTされた画像, bean_images-> 保存済みの画像
  def bean_images_shuld_save_at_least_one
    return if upload_images || bean_images.any?

    errors.add(:bean_images, 'は最低1枚登録してください')
  end

  # 生産国を選択することを要求する
  def bean_country_should_be_select_anyone
    return unless country_id&.zero?

    errors.add(:country, 'を選択してください')
  end

  # taste_tagsがMAX_TASTE_TAGS_COUNT以下であるか検証する
  def taste_tags_cannot_be_greater_than_max_taste_tags_count
    taste_ids = bean_taste_tags.map { |x| x[:mst_taste_tag_id] }
    return unless taste_ids.count > MAX_TASTE_TAGS_COUNT

    errors.add(:taste_tags, "は最大#{MAX_TASTE_TAGS_COUNT}つまでしか登録できません")
  end

  # 有効なtaste_tagsがMIN_TASTE_TAGS_COUNT以上であるか検証する
  # id=0 "選択されていません" e.g. [1, 0 ,0 ] -> [1].countが2以上であること
  def taste_tags_cannot_be_less_than_min_taste_tags_count
    taste_ids = bean_taste_tags.map { |x| x[:mst_taste_tag_id] }
    taste_ids.delete(0)
    return unless taste_ids.count < MIN_TASTE_TAGS_COUNT

    errors.add(:taste_tags, "は#{MIN_TASTE_TAGS_COUNT}つ以上登録してください")
  end

  # taste_tagsに重複がないか検証する
  # e.g. [1, 1, 2].count != [1,2].count の場合エラーを追加する
  def taste_tags_cannot_be_duplicated
    taste_ids = bean_taste_tags.map { |x| x[:mst_taste_tag_id] }
    taste_ids.delete(0)
    return if taste_ids.count == taste_ids.uniq.count

    errors.add(:taste_tags, 'が重複しています')
  end

  # upload_imagesがある場合は登録ずみの画像を削除し新たにcreateする
  def update_bean_images
    # 登録ずみの画像を全て削除する
    bean_images.each(&:destroy)
    upload_images.each do |img|
      bean_images.create!(image: img, bean_id: self.id)
    end
  end
end
