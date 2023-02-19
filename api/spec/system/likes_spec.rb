require 'rails_helper'

RSpec.describe 'Likes', type: :system, skip: true do
  let(:user) { create(:user) }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'Like CRUD' do
    describe 'index feature' do
      let!(:another_bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster, name: '他のコーヒー豆') }
      let!(:another_offer) { create(:offer, bean: another_bean) }
      before do
        sign_in user
        user.like_offers << offer
        visit home_users_path
      end
      it 'shows like offers' do
        click_link 'Likes'
        expect(current_path).to eq likes_path
        expect(page).to have_content 'お気に入り'
        expect(page).to have_selector("a[href='/offers/#{offer.id}']")
        expect(page).to have_content offer.bean.name
      end
    end

    describe 'create/delete feature', js: true do
      before do
        sign_in user
        user.following_roasters << roaster
      end

      context 'when a user does not have a like' do
        before { visit home_users_path }
        it 'should create a like for an offer' do
          expect do
            click_button 'like-button'
            expect(current_path).to eq home_users_path
            expect(page).to have_selector('#unlike-button')
          end.to change(Like, :count).by(1)
        end
      end

      context 'when a user has a like for a offer' do
        before do
          user.like_offers << offer
          visit likes_path
        end
        it 'should delete a like for an offer' do
          expect do
            click_button 'unlike-button'
            expect(current_path).to eq likes_path
            expect(page).to have_selector('#like-button')
          end.to change(Like, :count).by(-1)
        end
      end
    end
  end
end
