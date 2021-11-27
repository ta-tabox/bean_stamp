class MstRoastLevel < ApplicationRecord
  has_many :beans,
           dependent: :nullify,
           foreign_key: 'roast_level_id',
           inverse_of: :roast_level
end
