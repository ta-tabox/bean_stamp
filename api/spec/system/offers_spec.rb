require 'rails_helper'

RSpec.describe 'Offers', type: :system do
  describe 'Offer CRUD' do
    # ロースターに所属したユーザーを定義
    let(:user) { create(:user, :with_roaster) }
    let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: user.roaster) }
    let!(:offer) { create(:offer, bean: bean) }

    before do
      sign_in user
      visit home_roasters_path
    end

    describe 'index feature' do
      let(:recent_offer) { create(:offer, created_at: Time.current, bean: bean) }
      let(:old_offer) { create(:offer, created_at: Time.current.ago(3.days), bean: bean) }

      subject { click_link 'Offers' }

      it 'displays offers in order desc' do
        recent_offer
        old_offer
        subject
        expect(page.find('section > article:first-of-type')).to match_selector "#offer-#{recent_offer.id}"
        expect(page.find('section > article:last-of-type')).to match_selector "#offer-#{old_offer.id}"
      end
    end

    describe 'new creation feature' do
      subject { proc { click_button 'オファーする' } }

      before do
        visit beans_path
        find("article#bean-#{bean.id}").click_link 'オファー'
        fill_in 'オファー終了日', with: Time.zone.today.next_day(5)
        fill_in '焙煎日', with: Time.zone.today.next_day(10)
        fill_in '受け取り開始日', with: Time.zone.today.next_day(15)
        fill_in '受け取り終了日', with: Time.zone.today.next_day(20)
        find('#offer_price').fill_in with: 1000
        find('#offer_weight').fill_in with: 100
        find('#offer_amount').fill_in with: 10
      end

      context 'with correct form' do
        it 'creates a new Offer' do
          is_expected.to change(Offer, :count).by(1)
          expect(current_path).to eq offer_path Offer.last
          expect(page).to have_content 'オファーを作成しました'
          expect(page).to have_content bean.name
        end
      end
    end

    describe 'offer detail showing feature' do
      subject { visit offer_path offer }

      it "shows offer's and bean's informations" do
        subject
        # offerの情報が表示されているかの確認
        expect(page).to have_content offer.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content offer.ended_at.strftime('%Y/%m/%d')
        expect(page).to have_content offer.roasted_at.strftime('%Y/%m/%d')
        expect(page).to have_content offer.receipt_started_at.strftime('%Y/%m/%d')
        expect(page).to have_content offer.receipt_ended_at.strftime('%Y/%m/%d')
        expect(page).to have_content offer.price
        expect(page).to have_content offer.weight
        expect(page).to have_content offer.amount
        # beanの情報が表示されているかの確認
        expect(page).to have_selector("img[src*='sample.jpg']")
        expect(page).to have_content bean.name
        expect(page).to have_content bean.country
      end
    end

    describe 'offer editing feature' do
      subject { click_button '更新' }
      it "updates the offer's information" do
        visit edit_offer_path offer
        page.find('#offer_ended_at').set(Time.zone.today.next_day(7))
        page.find('#offer_roasted_at').set(Time.zone.today.next_day(12))
        page.find('#offer_receipt_started_at').set(Time.zone.today.next_day(17))
        page.find('#offer_receipt_ended_at').set(Time.zone.today.next_day(22))
        find('#offer_price').fill_in with: 1500
        find('#offer_weight').fill_in with: 200
        find('#offer_amount').fill_in with: 30
        subject
        expect(current_path).to eq offer_path offer
        expect(page).to have_content 'オファーを更新しました'
        expect(page).to have_content Time.zone.today.next_day(7).day
        expect(page).to have_content Time.zone.today.next_day(12).day
        expect(page).to have_content Time.zone.today.next_day(17).day
        expect(page).to have_content Time.zone.today.next_day(22).day
        expect(page).to have_content 1500
        expect(page).to have_content 200
        expect(page).to have_content 30
      end
    end

    describe 'delete offer feature', js: true do
      before { click_link 'Offers' }
      it 'deletes a offer at offers#index' do
        expect do
          find("article#offer-#{offer.id}").click_link '詳細'
          click_link '削除'
          accept_confirm
          expect(page).to have_content "コーヒー豆「#{offer.bean.name}」のオファーを1件削除しました"
          expect(page).to_not have_selector("a[href='/offers/#{offer.id}']")
          expect(current_path).to eq offers_path
        end.to change(Offer, :count).by(-1)
      end
      it 'deletes a offer at offers#edit' do
        expect do
          visit edit_offer_path offer
          click_link '削除する'
          accept_confirm
          expect(page).to have_content "コーヒー豆「#{offer.bean.name}」のオファーを1件削除しました"
          expect(page).to_not have_selector("a[href='/offers/#{offer.id}]")
          expect(current_path).to eq offers_path
        end.to change(Offer, :count).by(-1)
      end
    end
  end

  describe 'recommended offer feature' do
    let(:user_without_roaster) { create(:user) }
    let(:user_with_roaster) { create(:user, :with_roaster) }

    shared_context 'have rate for wants' do
      # 条件設定データ
      let(:floral_offer) { create(:offer, :end_of_sales, bean: floral_bean) }
      let(:berry_offer) { create(:offer, :end_of_sales, bean: berry_bean) }
      let(:floral_bean) { create(:bean, :with_image, :with_floral_tags) }
      let(:berry_bean) { create(:bean, :with_image, :with_berry_tags) }

      before do
        user.want_offers.push(floral_offer, berry_offer)
        user.wants.each { |want| want.update(receipted_at: Date.current) }
        user.wants.find_by(offer_id: floral_offer.id).excellent! # taste_group_id = 1
        user.wants.find_by(offer_id: berry_offer.id).good! # taste_group_id = 6
      end
    end

    before { sign_in user }

    context 'when a user not belonging to a roaster' do
      let(:user) { user_without_roaster }

      context 'when a user have no rate for wants' do
        let!(:same_area_offer) { create(:offer, bean: same_area_bean) }
        let(:same_area_bean) { create(:bean, :with_image, :with_3_taste_tags) }
        let!(:another_area_offer) { create(:offer, bean: another_area_bean) }
        let(:another_area_bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: another_area_roaster) }
        let(:another_area_roaster) { create(:roaster, prefecture_code: '1') }

        it 'shows a same area offer' do
          visit home_users_path
          within '#user-aside' do
            expect(page).to have_selector("article#recommended-offer-#{same_area_offer.id}")
            expect(page).to_not have_selector("article#recommended-offer-#{another_area_offer.id}")
          end
        end
      end

      context 'when a user have rate for wants' do
        let!(:favorite_offer) { create(:offer, :on_offering, bean: favorite_bean) }
        let!(:not_favorite_offer) { create(:offer, :on_offering, bean: not_favorite_bean) }
        let(:favorite_bean) { create(:bean, :with_image, :with_floral_berry_tags) }
        let(:not_favorite_bean) { create(:bean, :with_image, :with_other_other_tags) }

        include_context 'have rate for wants'
        it 'shows a favorite taste group offer' do
          visit home_users_path
          within '#user-aside' do
            expect(page).to have_selector("article#recommended-offer-#{favorite_offer.id}")
            expect(page).to_not have_selector("article#recommended-offer-#{not_favorite_offer.id}")
          end
        end
      end
    end

    context 'when a user belonging to a roaster' do
      let(:user) { user_with_roaster }

      let!(:my_offer) { create(:offer, bean: my_bean) }
      let(:my_bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: user.roaster) }
      let!(:another_offer) { create(:offer, bean: another_bean) }
      let(:another_bean) { create(:bean, :with_image, :with_3_taste_tags) }

      context 'when a user have no rate for wants' do
        it 'shows a same area offer' do
          visit home_users_path
          within '#user-aside' do
            expect(page).to have_selector("article#recommended-offer-#{another_offer.id}")
            expect(page).to_not have_selector("article#recommended-offer-#{my_offer.id}")
          end
        end
      end

      context 'when a user have rate for wants' do
        let!(:my_favorite_offer) { create(:offer, :on_offering, bean: my_favorite_bean) }
        let(:my_favorite_bean) { create(:bean, :with_image, :with_floral_berry_tags, roaster: user.roaster) }
        let!(:another_favorite_offer) { create(:offer, :on_offering, bean: another_favorite_bean) }
        let(:another_favorite_bean) { create(:bean, :with_image, :with_floral_berry_tags) }
        let!(:not_favorite_offer) { create(:offer, :on_offering, bean: not_favorite_bean) }
        let(:not_favorite_bean) { create(:bean, :with_image, :with_other_other_tags) }

        include_context 'have rate for wants'
        it 'shows a favorite taste group offer' do
          visit home_users_path
          within '#user-aside' do
            expect(page).to have_selector("article#recommended-offer-#{another_favorite_offer.id}")
            expect(page).to_not have_selector("article#recommended-offer-#{my_favorite_offer.id}")
            expect(page).to_not have_selector("article#recommended-offer-#{not_favorite_offer.id}")
          end
        end
      end
    end
  end
end
