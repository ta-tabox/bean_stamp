require 'rails_helper'

RSpec.describe MstTasteTag, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:bean_taste_tags).dependent(:destroy) }
    it { is_expected.to have_many(:beans).through(:bean_taste_tags) }
    it { is_expected.to have_many(:members).class_name('MstTasteTag').with_foreign_key('taste_group_id').inverse_of(:taste_group) }
    it { is_expected.to belong_to(:taste_group).class_name('MstTasteTag') }
  end
end
