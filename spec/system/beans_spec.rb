require 'rails_helper'

RSpec.describe 'Beans', type: :system do
  # ロースターに所属したユーザーを定義
  let(:user) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, created_at: Time.current.yesterday, roaster: user.roaster) }

  before do
    sign_in user
    visit root_path
  end

  describe 'Bean CRUD' do
    describe 'index feature' do
      let(:recent_bean) { create(:bean, :with_image, :with_3_taste_tags, name: 'recent_bean', created_at: Time.current, roaster: user.roaster) }
      let(:old_bean) { create(:bean, :with_image, :with_3_taste_tags, name: 'old_bean', created_at: Time.current.ago(3.days), roaster: user.roaster) }
      subject { click_link 'beans' }

      it 'displays beans in order desc' do
        recent_bean
        old_bean
        subject
        expect(page.find('ol > div:first-of-type')).to have_selector "li#bean-#{recent_bean.id}"
        expect(page.find('ol > div:last-of-type')).to have_selector "li#bean-#{old_bean.id}"
      end
    end

    describe 'new creation feature' do
      subject { proc { click_button '登録' } }

      before do
        click_link 'beans'
        click_link '新規作成'
        fill_in 'タイトル', with: 'テストビーンズ'
        fill_in '生産国', with: 'エチオピア'
        select '中煎り', from: '焙煎度'
        fill_in '地域', with: 'イルガチェフェ'
        fill_in '農園', with: 'テストファーム'
        fill_in '品種', with: 'アビシニカ'
        fill_in '標高', with: '1500'
        fill_in '精製方法', with: 'ナチュラル'
        # 収穫時期にデータを入れる方法がわからない
        # fill_in '収穫時期', with: '2022-01'
        # page.find('#bean_cropped_at').set('2020-01-01')
        fill_in 'コーヒー紹介', with: 'テストメッセージ'
        select 'FLORAL', from: 'bean[bean_taste_tags_attributes][0][mst_taste_tag_id]'
        select 'BLACK TEA', from: 'bean[bean_taste_tags_attributes][1][mst_taste_tag_id]'
        select 'CHAMOMILE', from: 'bean[bean_taste_tags_attributes][2][mst_taste_tag_id]'
      end

      context 'with correct form' do
        before { attach_file 'bean_images[image][]', Rails.root.join('spec/fixtures/sample.jpg') }
        it 'creates a new Bean' do
          is_expected.to change(Bean, :count).by(1)
          expect(current_path).to eq bean_path Bean.first
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

      context 'with too many images' do
        it 'shows alert and does not create a new Bean' do
          click_link 'beans'
          click_link '新規作成'
          attach_file 'bean_images[image][]',
                      [Rails.root.join('spec/fixtures/sample.jpg'),
                       Rails.root.join('spec/fixtures/sample.jpg'),
                       Rails.root.join('spec/fixtures/sample.jpg'),
                       Rails.root.join('spec/fixtures/sample.jpg'),
                       Rails.root.join('spec/fixtures/sample.jpg')], multiple: true
          accept_alert('画像は最大4枚まで投稿できます')
          is_expected.to_not change(Bean, :count)
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
        click_link 'beans'
        find("li#bean-#{bean.id}").click_link '編集'
        fill_in 'タイトル', with: 'アップデートビーンズ'
        fill_in '生産国', with: 'ブラジル'
        select '浅煎り', from: '焙煎度'
        fill_in '地域', with: 'ブラジル'
        fill_in '農園', with: 'アップデートファーム'
        fill_in '品種', with: 'ブルボン'
        fill_in '標高', with: '800'
        fill_in '精製方法', with: 'ウォッシュド'
        fill_in 'コーヒー紹介', with: 'アップデートメッセージ'
        select 'ROSE', from: 'bean[bean_taste_tags_attributes][0][mst_taste_tag_id]'
        select 'JASMINE', from: 'bean[bean_taste_tags_attributes][1][mst_taste_tag_id]'
        select 'BERRY', from: 'bean[bean_taste_tags_attributes][2][mst_taste_tag_id]'
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
      before { click_link 'beans' }

      context 'When applorch at beans#index' do
        it 'deletes a bean' do
          expect do
            find("li#bean-#{bean.id}").click_link '削除'
            accept_confirm
            expect(current_path).to eq beans_path
          end.to change(Bean, :count).by(-1)
          expect(page).to have_content "コーヒー豆「#{bean.name}」を削除しました"
          expect(page).to_not have_selector("a[href='/beans/#{bean.id}]")
        end
      end

      context 'When applorch at beans#edit' do
        before { find("li#bean-#{bean.id}").click_link '編集' }

        it 'deletes a bean' do
          expect do
            click_link '削除する'
            accept_confirm
            expect(current_path).to eq beans_path
          end.to change(Bean, :count).by(-1)
          expect(page).to have_content "コーヒー豆「#{bean.name}」を削除しました"
          expect(page).to_not have_selector("a[href='/beans/#{bean.id}]")
        end
      end
    end
  end
end
