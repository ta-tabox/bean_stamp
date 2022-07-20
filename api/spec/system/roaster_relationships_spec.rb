require 'rails_helper'

RSpec.describe 'RoasterRelationships', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, name: '他のテストユーザー') }
  let(:roaster) { create(:roaster) }
  let(:following_roaster) { create(:roaster, name: 'following_roaster') }
  let(:another_roaster) { create(:roaster, name: 'another_roaster') }

  before { sign_in user }

  describe 'User#following' do
    before do
      user.following_roasters << following_roaster
      visit home_users_path
      click_link 'Follow'
    end
    # フォローしているロースターのみ表示しているか
    it 'shows a roaster who followed by the user' do
      expect(page).to have_content following_roaster.name
      expect(page).to have_selector("a[href='/roasters/#{following_roaster.id}']")
      expect(page).to_not have_content another_roaster.name
    end
  end

  describe 'Roaster#followers' do
    before do
      visit roaster_path roaster
    end
    it 'shows stats of followers counts' do
      expect do
        click_button 'Follow'
        expect(find('#followers')).to have_content(roaster.followers.count.to_s)
      end.to change(RoasterRelationship, :count).by(1)
      find('.stats').click_link 'followers'
      expect(current_path).to eq followers_roaster_path roaster
      expect(page).to have_content user.name
    end
  end
end
