require 'rails_helper'

RSpec.describe 'Wants', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, name: '他のテストユーザー') }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'Want CRUD' do
    describe 'index feature' do
      let!(:another_bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster, name: '他のコーヒー豆') }
      let!(:another_offer) { create(:offer, bean: another_bean) }
      before do
        sign_in user
        user.wanting_offers << offer
        visit home_users_path
      end
      it 'shows wanting offers' do
        click_link 'Wants'
        expect(current_path).to eq wants_path
        expect(page).to have_content 'ウォンツ'
        expect(find("#offer-#{offer.id}-wants-count")).to have_content(offer.wants.count.to_s)
        expect(page).to have_content offer.bean.name
        expect(page).to_not have_content another_offer.bean.name
      end
    end

    describe 'create/delete feature' do
      before do
        sign_in user
        user.following_roasters << roaster
      end

      context 'when a user does not have a want' do
        before { visit home_users_path }
        it 'should create a want for an offer' do
          expect do
            click_button 'want-button'
            expect(find("#offer-#{offer.id}-wants-count")).to have_content(offer.wants.count.to_s)
          end.to change(Want, :count).by(1)
        end
      end

      context 'when a user has a want for a offer' do
        before do
          user.wanting_offers << offer
          visit home_users_path
        end
        it 'should delete a want for an offer' do
          expect do
            click_button 'unwant-button'
            expect(find("#offer-#{offer.id}-wants-count")).to have_content(offer.wants.count.to_s)
          end.to change(Want, :count).by(-1)
        end
      end
    end

    describe 'offer/:id/wants page' do
      let(:user_belonging_a_roaster) { create(:user, roaster: roaster) }
      let(:another_user) { create(:user, name: '他のユーザー') }

      before do
        sign_in user_belonging_a_roaster
        another_user.wanting_offers << offer
        visit offers_path
      end
      it 'shows wanting offers' do
        find('.stats').click_link 'wants'
        expect(current_path).to eq wanted_users_offer_path(offer)
        expect(page).to have_content 'ウォンツしたユーザー'
        expect(page).to have_content another_user.name
      end
    end
  end
end
