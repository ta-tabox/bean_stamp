class RoasterRelationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :roaster

  validates :follower_id, presence: true
  validates :roaster_id, presence: true, uniqueness: { scope: :follower_id, message: 'は既にフォロー済みです' }
end
