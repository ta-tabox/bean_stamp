class RoasterRelationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :roaster

  validates :follower_id, presence: true
  validates :roaster_id, presence: true
end
