require 'rails_helper'

RSpec.describe 'Notifications', type: :system, skip: true do
  let(:user) { create(:user, roaster: roaster) }
  let(:roaster) { create(:roaster) }
  let(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  # 本日でオファー終わり
  let(:offering_offer) { create(:offer, ended_at: Date.current, bean: bean) }
  # 本日までロースト中
  let(:roasting_offer) { create(:offer, :on_roasting, roasted_at: Date.current, bean: bean) }
  # 本日まで準備中、明日から受付開始
  let(:preparing_offer) { create(:offer, :on_preparing, receipt_started_at: Date.current.next_day(1), bean: bean) }
  # 本日まで受付中
  let(:selling_offer) { create(:offer, :on_selling, receipt_ended_at: Date.current, bean: bean) }
  # 昨日まで受付中、本日は受付終了
  let(:sold_offer) { create(:offer, :end_of_sales, receipt_ended_at: Date.current.prev_day(1), bean: bean) }

  before { sign_in user }

  describe 'user aside notification' do
    context 'when a user has no wants' do
      it 'show no notification message' do
        visit home_users_path
        within('#user-aside') do
          expect(page).to have_content 'お知らせはありません'
        end
      end
    end

    context 'when a user has a on roasting want' do
      before do
        user.want_offers << roasting_offer
      end
      it 'show a message' do
        visit home_users_path
        within('#user-aside') do
          expect(page).to have_content 'ロースト期間のウォンツが1件あります'
          expect(page).to_not have_content 'お知らせはありません'
        end
      end
    end
    context 'when a user has a unreceipted want' do
      before do
        user.want_offers << selling_offer
      end
      it 'show a message' do
        visit home_users_path
        within('#user-aside') do
          expect(page).to have_content '未受け取りのウォンツが1件あります'
          expect(page).to_not have_content 'お知らせはありません'
        end
      end
    end
    context 'when a user has a only receipted want' do
      before do
        user.want_offers << selling_offer
        user.wants.first.update(receipted_at: Date.current)
      end
      it 'show no notification message' do
        visit home_users_path
        within('#user-aside') do
          expect(page).to have_content 'お知らせはありません'
          expect(page).to_not have_content '未受け取りのウォンツが1件あります'
        end
      end
    end
    context 'when a user has another wants' do
      before do
        user.want_offers << offering_offer
        user.want_offers << preparing_offer
        user.want_offers << sold_offer
      end
      it 'show no notification message' do
        visit home_users_path
        within('#user-aside') do
          expect(page).to have_content 'お知らせはありません'
        end
      end
    end
  end

  # ロースター用の通知機能のテスト
  describe 'roaster aside notification' do
    context 'when a roaster has no offers' do
      it 'show no notification message' do
        visit home_roasters_path
        within('#roaster-aside') do
          expect(page).to have_content 'お知らせはありません'
        end
      end
    end

    context 'when a roaster has a on roasting offer' do
      before { roasting_offer }

      it 'show a message' do
        visit home_roasters_path
        within('#roaster-aside') do
          expect(page).to have_content 'ロースト期間のオファーが1件あります'
          expect(page).to_not have_content 'お知らせはありません'
        end
      end
    end
    context 'when a roaster has a selling offer' do
      before { selling_offer }

      it 'show a message' do
        visit home_roasters_path
        within('#roaster-aside') do
          expect(page).to have_content '受け取り期間のオファーが1件あります'
          expect(page).to_not have_content 'お知らせはありません'
        end
      end
    end
    context 'when a roaster has another offers' do
      before do
        offering_offer
        preparing_offer
        sold_offer
      end

      it 'show no notification message' do
        visit home_roasters_path
        within('#roaster-aside') do
          expect(page).to have_content 'お知らせはありません'
        end
      end
    end
  end
end
