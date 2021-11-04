class Roaster < ApplicationRecord
  before_validation :before_validations
  has_many :users, dependent: :nullify
  validates :name, presence: true
  validates :phone_number,
            presence: true,
            numericality: {
              only_integer: true,
            },
            length: {
              in: 10..11,
            }
  validates :address, presence: true
  validates :describe, length: { maximum: 300 }

  private

  def before_validations
    # phone_numberの文字列から先頭と文末のスペースを除去
    phone_number.strip!
  end
end
