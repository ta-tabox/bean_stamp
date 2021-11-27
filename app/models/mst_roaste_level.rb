class MstRoasteLevel < ApplicationRecord
  has_many :beans,
           dependent: :nullify,
           foreign_key: 'roaste_level_id',
           inverse_of: :roaste_level
end
