require 'rails_helper'

RSpec.describe 'Offers', type: :system do
  # ロースターに所属したユーザーを定義
  let(:user) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: user.roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  before do
    sign_in user
    visit root_path
  end

  describe 'Offer CRUD' do
    describe 'index feature' do
      let(:recent_offer) { create(:offer, created_at: Time.current, bean: bean) }
      let(:old_offer) { create(:offer, created_at: Time.current.ago(3.days), bean: bean) }

      subject { click_link 'offers' }

      it 'displays offers in order desc' do
        recent_offer
        old_offer
        subject
        expect(page.find('ol > div:first-of-type')).to have_selector "li#offer-#{recent_offer.id}"
        expect(page.find('ol > div:last-of-type')).to have_selector "li#offer-#{old_offer.id}"
      end

      it 'displays link for edit and delete' do
        subject
        expect(page).to have_content '編集'
        expect(page).to have_selector("a[href='/offers/#{offer.id}/edit']")
        expect(page).to have_content '削除'
        expect(page).to have_selector 'a[data-method=delete]', text: '削除'
      end
    end

    describe 'new creation feature' do
      subject { proc { click_button 'オファーする' } }

      before do
        click_link 'beans'
        find("li#bean-#{bean.id}").click_link 'オファー'
        fill_in 'オファー終了日', with: Time.zone.today.next_day(5)
        fill_in '焙煎日', with: Time.zone.today.next_day(10)
        fill_in '受け取り開始日', with: Time.zone.today.next_day(15)
        fill_in '受け取り終了日', with: Time.zone.today.next_day(20)
        fill_in '販売価格', with: 1000
        fill_in '内容量', with: 100
        fill_in '数量', with: 10
      end

      context 'with correct form' do
        it 'creates a new Offer' do
          is_expected.to change(Offer, :count).by(1)
          expect(current_path).to eq offer_path Offer.first
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
        expect(page).to have_content offer.created_at
        expect(page).to have_content offer.ended_at
        expect(page).to have_content offer.roasted_at
        expect(page).to have_content offer.receipt_started_at
        expect(page).to have_content offer.receipt_ended_at
        expect(page).to have_content offer.price
        expect(page).to have_content offer.weight
        expect(page).to have_content offer.amount
        # beanの情報が表示されているかの確認
        expect(page).to have_selector("img[src$='sample.jpg']")
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
        fill_in '販売価格', with: 1500
        fill_in '内容量', with: 150
        fill_in '数量', with: 15
        subject
        expect(current_path).to eq offer_path offer
        expect(find('#offer_ended_at')).to have_content Time.zone.today.next_day(7)
        expect(find('#offer_roasted_at')).to have_content Time.zone.today.next_day(12)
        expect(find('#offer_receipt_started_at')).to have_content Time.zone.today.next_day(17)
        expect(find('#offer_receipt_ended_at')).to have_content Time.zone.today.next_day(22)
        expect(find('#offer_price')).to have_content 1500
        expect(find('#offer_weight')).to have_content 150
        expect(find('#offer_amount')).to have_content 15
      end
    end

    describe 'delete offer feature' do
      before { click_link 'offers' }
      it 'deletes a offer at offers#index' do
        find("li#offer-#{offer.id}").click_link '削除'
        expect do
          accept_confirm
          expect(current_path).to eq offers_path
        end.to change(Offer, :count).by(-1)
        expect(page).to have_content "コーヒー豆「#{offer.bean.name}」のオファーを1件削除しました"
        expect(page).to_not have_selector("a[href='/offers/#{offer.id}]")
      end
      it 'deletes a offer at offers#edit' do
        visit edit_offer_path offer
        click_link '削除する'
        expect do
          accept_confirm
          expect(current_path).to eq offers_path
        end.to change(Offer, :count).by(-1)
        expect(page).to have_content "コーヒー豆「#{offer.bean.name}」のオファーを1件削除しました"
        expect(page).to_not have_selector("a[href='/offers/#{offer.id}]")
      end
    end
  end
end
