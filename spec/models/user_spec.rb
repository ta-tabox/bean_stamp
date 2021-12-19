require 'rails_helper'

RSpec.describe User, type: :model, focus: true do
  # name, email, passwordがあれば有効な状態であること
  it 'is valid with a name, email and password' do
    user = build(:user)
    expect(user).to be_valid
  end
  describe 'バリデーションのテスト' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
