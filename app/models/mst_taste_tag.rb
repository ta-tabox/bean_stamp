class MstTasteTag < ApplicationRecord
  has_many :bean_taste_tags, dependent: :destroy
  has_many :beans, through: :bean_taste_tags

  # 自己結合によりtaste_tag同士でgroup分けを行う
  # @taste_tag.membersにより自身のidに属する子tasteを取得
  has_many :members,
           class_name: 'MstTasteTag',
           foreign_key: 'taste_group_id',
           dependent: :restrict_with_exception,
           inverse_of: :taste_group

  # @taste_tag.taste_groupで自身が所属する親tasteを取得
  # @taste_tag.taste_group.membersで自身と同じ親tasteを持ったレコードを取得
  belongs_to :taste_group, class_name: 'MstTasteTag'

  def name_for_select
    name.capitalize
  end
end
