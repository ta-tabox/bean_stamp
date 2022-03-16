require 'rails_helper'

RSpec.describe 'Beans', type: :system do
  # ロースターに所属したユーザーを定義
  let(:user) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, created_at: Time.current.yesterday, roaster: user.roaster) }

  before do
    sign_in user
    visit home_roasters_path
  end

  describe 'Bean CRUD' do
    describe 'index feature' do
      let(:recent_bean) { create(:bean, :with_image, :with_3_taste_tags, name: 'recent_bean', created_at: Time.current, roaster: user.roaster) }
      let(:old_bean) { create(:bean, :with_image, :with_3_taste_tags, name: 'old_bean', created_at: Time.current.ago(3.days), roaster: user.roaster) }
      subject { within('ul') { click_link 'Beans' } }

      it 'displays beans in order desc' do
        recent_bean
        old_bean
        subject
        expect(page.find('section > article:first-of-type')).to match_selector "#bean-#{recent_bean.id}"
        expect(page.find('section > article:last-of-type')).to match_selector "#bean-#{old_bean.id}"
      end
    end

    describe 'new creation feature' do
      subject { proc { click_button '登録' } }

      before do
        within('ul') { click_link 'Beans' }
        click_link '新規作成'
        fill_in 'タイトル', with: 'テストビーンズ'
        fill_in '生産国', with: 'エチオピア'
        find('#bean_roast_level_id').select '中煎り'
        fill_in '地域', with: 'イルガチェフェ'
        fill_in '農園', with: 'テストファーム'
        fill_in '品種', with: 'アビシニカ'
        fill_in '標高', with: '1500'
        fill_in '精製方法', with: 'ナチュラル'
        # 収穫時期にデータを入れる方法がわからない
        # fill_in '収穫時期', with: '2022-01'
        # page.find('#bean_cropped_at').set('2020-01-01')
        find('#bean_describe').fill_in with: 'テストメッセージ'
        select 'loral', from: 'bean[bean_taste_tags_attributes][0][mst_taste_tag_id]'
        select 'Black tea', from: 'bean[bean_taste_tags_attributes][1][mst_taste_tag_id]'
        select 'Chamomile', from: 'bean[bean_taste_tags_attributes][2][mst_taste_tag_id]'
      end

      context 'with correct form' do
        before { attach_file 'bean_images[image][]', Rails.root.join('spec/fixtures/sample.jpg') }
        it 'creates a new Bean' do
          is_expected.to change(Bean, :count).by(1)
          expect(current_path).to eq bean_path Bean.last
          expect(page).to have_content 'コーヒー豆を登録しました'
        end
      end

      context 'with no images' do
        it 'does not create a new Bean' do
          is_expected.to_not change(Bean, :count)
          expect(current_path).to eq beans_path
          expect(page).to have_content 'イメージは最低1枚登録してください'
        end
      end
    end

    describe 'bean detail showing feature' do
      subject { visit bean_path bean }

      it "shows bean's informations" do
        subject
        expect(page).to have_selector("img[src$='sample.jpg']")
        expect(page).to have_content bean.name
        expect(page).to have_content bean.country
        expect(page).to have_content bean.roast_level.name
        expect(page).to have_content bean.subregion
        expect(page).to have_content bean.farm
        expect(page).to have_content bean.variety
        expect(page).to have_content bean.process
        expect(page).to have_content "#{bean.elevation} m"
        expect(page).to have_content "#{bean.cropped_at.year}年 #{bean.cropped_at.month}月"
        expect(page).to have_content bean.describe
        expect(page).to have_content bean.acidity
        expect(page).to have_content bean.flavor
        expect(page).to have_content bean.body
        expect(page).to have_content bean.bitterness
        expect(page).to have_content bean.sweetness
        expect(page).to have_content bean.taste_tags[0].name
        expect(page).to have_content bean.taste_tags[1].name
        expect(page).to have_content bean.taste_tags[2].name
        expect(page).to have_content '編集'
        expect(page).to have_selector("a[href='/beans/#{bean.id}/edit']")
      end
    end

    describe 'bean editing feature' do
      subject { click_button '更新' }

      it "updates the bean's information" do
        within('ul') { click_link 'Beans' }
        find("article#bean-#{bean.id}").click_link '詳細'
        click_link '編集'
        fill_in 'タイトル', with: 'アップデートビーンズ'
        fill_in '生産国', with: 'ブラジル'
        find('#bean_roast_level_id').select '浅煎り'
        fill_in '地域', with: 'ブラジル'
        fill_in '農園', with: 'アップデートファーム'
        fill_in '品種', with: 'ブルボン'
        fill_in '標高', with: '800'
        fill_in '精製方法', with: 'ウォッシュド'
        find('#bean_describe').fill_in with: 'アップデートメッセージ'
        select 'Rose', from: 'bean[bean_taste_tags_attributes][0][mst_taste_tag_id]'
        select 'Jasmine', from: 'bean[bean_taste_tags_attributes][1][mst_taste_tag_id]'
        select 'Berry', from: 'bean[bean_taste_tags_attributes][2][mst_taste_tag_id]'
        subject
        expect(current_path).to eq bean_path bean
        expect(page).to have_content 'コーヒー豆情報を更新しました'
        expect(page).to have_content 'アップデートビーンズ'
        expect(page).to have_content 'ブラジル'
        expect(page).to have_content '浅煎り'
        expect(page).to have_content 'アップデートファーム'
        expect(page).to have_content 'ブルボン'
        expect(page).to have_content '800 m'
        expect(page).to have_content 'ウォッシュド'
        expect(page).to have_content 'アップデートメッセージ'
        expect(page).to have_content 'ROSE'
        expect(page).to have_content 'JASMINE'
        expect(page).to have_content 'BERRY'
      end
    end

    describe 'delete bean feature' do
      before { within('ul') { click_link 'Beans' } }

      it 'deletes a bean' do
        expect do
          find("article#bean-#{bean.id}").click_link '詳細'
          click_link '削除'
          accept_confirm
          expect(page).to have_content "コーヒー豆「#{bean.name}」を削除しました"
          expect(page).to_not have_selector("a[href='/beans/#{bean.id}]")
          expect(current_path).to eq beans_path
        end.to change(Bean, :count).by(-1)
      end
    end
  end
end
