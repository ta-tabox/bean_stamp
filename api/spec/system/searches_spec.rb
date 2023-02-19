require 'rails_helper'

RSpec.describe 'Searches', type: :system, skip: true do
  let(:user) { create(:user) }
  let(:roaster) { create(:roaster) }
  let(:target_roaster) { create(:roaster, name: 'target_roaster', prefecture_code: '13') } # 東京
  let(:another_roaster) { create(:roaster, name: 'another_roaster', prefecture_code: '34') } # 広島

  before do
    sign_in user
  end

  describe 'index feature' do
    let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
    let!(:offer) { create(:offer, bean: bean) }

    before do
      visit home_users_path
    end

    it 'shows search form', js: true do
      click_link 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content '検索'
      expect(page).to have_css('.form-main')
      # ロースター検索フォームの表示
      find('#roaster-tab').click
      expect(page).to have_css('#roaster_search')
      expect(page).to_not have_css('#offer_search')
      # オファー検索フォームの表示
      find('#offer-tab').click
      expect(page).to_not have_css('#roaster_search')
      expect(page).to have_css('#offer_search')
    end
  end

  # ロースター検索機能
  describe 'roaster search feature', js: true do
    before do
      target_roaster
      another_roaster
      visit searches_path
      find('#roaster-tab').click
    end

    context 'when click search button' do
      it 'shows roasters and roaster search form' do
        click_button '検索'
        expect(current_path).to eq roaster_searches_path
        expect(page).to have_content target_roaster.name
        expect(page).to have_content another_roaster.name
      end
    end

    context 'when click clear button' do
      it 'shows roasters and roaster search form' do
        click_link 'クリア'
        expect(current_path).to eq roaster_searches_path
      end
    end

    # ロースター店舗名による検索
    describe 'searche for roaster.name' do
      context 'when matching word' do
        it 'shows a target_roaster' do
          fill_in 'roaster_search_name_cont', with: 'target'
          click_button '検索'
          expect(page).to have_content target_roaster.name
          expect(page).to_not have_content another_roaster.name
        end
      end
      context 'when not matching word' do
        it 'does not show roastetrs' do
          fill_in 'roaster_search_name_cont', with: 'missmatch'
          click_button '検索'
          expect(page).to have_content 'ロースターが見つかりませんでした'
          expect(page).to_not have_content roaster.name
        end
      end
    end

    # ロースター都道府県による検索
    describe 'searche for roaster.prefecture_code' do
      context 'when matching word' do
        it 'shows a target_roaster' do
          find('#roaster_search_prefecture_code_eq').select '東京都'
          click_button '検索'
          expect(page).to have_content target_roaster.name
          expect(page).to_not have_content another_roaster.name
        end
      end
      context 'when not matching word' do
        it 'does not show roastetrs' do
          find('#roaster_search_prefecture_code_eq').select '北海道'
          click_button '検索'
          expect(page).to have_content 'ロースターが見つかりませんでした'
          expect(page).to_not have_content target_roaster.name
          expect(page).to_not have_content another_roaster.name
        end
      end
    end
  end

  # オファー検索機能
  describe 'offer search feature', js: true do
    let!(:bean) { create(:bean, :with_image, :with_3_taste_tags) }
    let!(:offer) { create(:offer, bean: bean) }
    # 東京, ブラジル, 浅煎り, taste_tag Chamomileを含む
    let!(:target_bean) do
      create(:bean, :with_image, :with_3_taste_tags, name: 'target_bean', country: MstCountry.find(1), roast_level: MstRoastLevel.find(1),
                                                     roaster: target_roaster)
    end
    let!(:target_offer) { create(:offer, bean: target_bean) }
    # 広島, エチオピア, 中煎り, taste_tag Chamomileを含まない
    let!(:another_bean) { create(:bean, :with_image, :with_2_taste_tags, name: 'another_bean', roaster: another_roaster) }
    let!(:another_offer) { create(:offer, bean: another_bean) }

    before do
      visit searches_path
      find('#offer-tab').click
    end

    context 'when click search button' do
      it 'shows offers and offer search form' do
        click_button '検索'
        expect(current_path).to eq offer_searches_path
        expect(page).to have_content target_bean.name
        expect(page).to have_content another_bean.name
      end
    end

    context 'when click clear button' do
      it 'shows offers and offer search form' do
        click_link 'クリア'
        expect(current_path).to eq offer_searches_path
      end
    end

    # ロースター都道府県による検索
    describe "searche for roaster's prefecture_code" do
      context 'when matching word' do
        it 'shows a target_offer' do
          find('#offer_search_bean_roaster_prefecture_code_eq').select '東京都'
          click_button '検索'
          expect(page).to have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
      context 'when not matching word' do
        it 'does not show roastetrs' do
          find('#offer_search_bean_roaster_prefecture_code_eq').select '北海道'
          click_button '検索'
          expect(page).to have_content 'オファーが見つかりませんでした'
          expect(page).to_not have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
    end

    # コーヒー生産国による検索
    describe "searche for bean's country" do
      context 'when matching word' do
        it 'shows a target_offer' do
          find('#offer_search_bean_country_id_eq').select 'ブラジル'
          click_button '検索'
          expect(page).to have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
      context 'when not matching word' do
        it 'does not show roastetrs' do
          find('#offer_search_bean_country_id_eq').select 'ケニア'
          click_button '検索'
          expect(page).to have_content 'オファーが見つかりませんでした'
          expect(page).to_not have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
    end

    # コーヒー豆焙煎度による検索
    describe "searche for bean's roast_level" do
      context 'when matching word' do
        it 'shows a target_offer' do
          find('#offer_search_bean_roast_level_id_eq').select '浅煎り'
          click_button '検索'
          expect(page).to have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
      context 'when not matching word' do
        it 'does not show roastetrs' do
          find('#offer_search_bean_roast_level_id_eq').select '深煎り'
          click_button '検索'
          expect(page).to have_content 'オファーが見つかりませんでした'
          expect(page).to_not have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
    end

    # コーヒー豆のフレーバーによる検索
    describe "searche for beans's taste_tags" do
      context 'when matching word' do
        it 'shows a target_offer' do
          find('#offer_search_bean_taste_tags_id_eq').select 'Chamomile'
          click_button '検索'
          expect(page).to have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
      context 'when not matching word' do
        it 'does not show roastetrs' do
          find('#offer_search_bean_taste_tags_id_eq').select 'Rose'
          click_button '検索'
          expect(page).to have_content 'オファーが見つかりませんでした'
          expect(page).to_not have_content target_bean.name
          expect(page).to_not have_content another_bean.name
        end
      end
    end
  end
end
