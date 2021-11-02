class Roaster < ApplicationRecord
  has_many :users, dependent: :nullify
end
