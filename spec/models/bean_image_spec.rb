require 'rails_helper'

RSpec.describe BeanImage, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:bean) }
  end
end
