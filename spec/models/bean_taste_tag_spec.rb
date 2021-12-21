require 'rails_helper'

RSpec.describe BeanTasteTag, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:bean) }
    it { is_expected.to belong_to(:mst_taste_tag) }
  end
end
