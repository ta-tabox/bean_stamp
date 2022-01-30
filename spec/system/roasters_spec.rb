require 'rails_helper'

RSpec.describe 'Roasters', type: :system do
  describe 'Roaster CRUD' do
    let(:roaster) { create(:roaster, :with_image) }
    let(:another_roaster) { create(:roaster, :with_image, name: '他のテストロースター') }
    let(:user_not_belonging_a_roaster) { create(:user) }
    let(:user_belonging_a_roaster) { create(:user, roaster: roaster) }
    let(:user_belonging_an_another_roaster) { create(:user, roaster: another_roaster) }

    describe 'index feature' do
      pending 'ロースター一覧表示機能、検索機能のテスト'
    end

    describe 'new registration feature' do
      subject { proc { click_button '登録' } }

      context 'when user is not belonging to a roaster' do
        before do
          sign_in user_not_belonging_a_roaster
          visit root_path
        end

        before do
          click_link 'my page'
          click_link '編集'
          click_link 'こちら'

          fill_in '店舗名', with: 'テストロースター'
          fill_in '電話番号', with: '0123456789'
          select '東京都', from: '都道府県'
          fill_in '住所', with: '渋谷区***-****'
          fill_in '店舗紹介', with: 'テストメッセージ'
        end

        context 'with correct form' do
          it 'creates a new roaster' do
            is_expected.to change(Roaster, :count).by(1)
            expect(current_path).to eq roaster_path Roaster.last
            expect(page).to have_content 'ロースター登録が完了しました'
          end
        end

        context 'with a image' do
          it 'uploads a image' do
            attach_file 'roaster[image]', Rails.root.join('spec/fixtures/sample.jpg')
            is_expected.to change(Roaster, :count).by(1)
            expect(current_path).to eq roaster_path Roaster.last
            expect(page).to have_content 'ロースター登録が完了しました'
            expect(page).to have_selector("img[src$='sample.jpg']")
          end
        end
      end
    end

    describe 'roaster detail showing feature' do
      let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, name: 'following_bean', roaster: roaster) }
      let!(:offer) { create(:offer, bean: bean) }
      subject { visit roaster_path roaster }

      shared_examples "shows roaster's informations" do
        it {
          subject
          expect(page).to have_content roaster.name
          expect(page).to have_content roaster.prefecture.name
          expect(page).to have_content roaster.address
          expect(page).to have_content roaster.describe
          expect(page).to have_selector("img[src$='sample.jpg']")
        }
      end

      context 'when user is not belonging to a roaster' do
        before do
          sign_in user_not_belonging_a_roaster
        end

        it_behaves_like "shows roaster's informations"

        pending 'ロースター詳細ページに電話番号を表示する' do
          expect(page).to have_content roaster.phone_number
        end

        it 'does not display a edit button' do
          subject
          expect(page).to_not have_content '編集'
          expect(page).to_not have_selector("a[href='/roasters/#{roaster.id}/edit']")
        end

        it 'shows an offer created by the roaster' do
          subject
          expect(page).to have_content bean.name
          expect(page).to have_selector("a[href='/offers/#{offer.id}']")
          expect(page).to_not have_selector("a[href='/offers/#{offer.id}/edit']")
        end
      end

      context 'when user belonging to the roaster' do
        before do
          sign_in user_belonging_a_roaster
        end

        it_behaves_like "shows roaster's informations"

        it 'display a edit button' do
          subject
          expect(page).to have_selector("a[href='/roasters/#{roaster.id}/edit']")
          expect(page).to have_content '編集'
        end

        it 'shows an offer and shows edit and delete link' do
          subject
          expect(page).to have_content bean.name
          expect(page).to have_selector("a[href='/offers/#{offer.id}']")
          expect(page).to have_selector("a[href='/offers/#{offer.id}/edit']")
          expect(page).to have_selector('a[data-method=delete]', text: '削除')
        end
      end

      context 'when user is not belonging to the another_roaster' do
        before do
          sign_in user_belonging_an_another_roaster
        end

        it_behaves_like "shows roaster's informations"

        it 'does not display a edit button' do
          subject
          expect(page).to_not have_content '編集'
          expect(page).to_not have_selector("a[href='/roasters/#{roaster.id}/edit']")
        end
      end
    end

    describe 'roaster editing feature' do
      context 'when user is belonging to a roaseter' do
        before do
          sign_in user_belonging_a_roaster
          visit root_path
        end

        it 'does not desplay link for /roasters/new but /roasters/[:id]/edit in users/edit' do
          click_link 'my page'
          click_link '編集'
          expect(page).to_not have_selector("a[href='/roasters/new']")
          expect(page).to have_selector("a[href='/roasters/#{roaster.id}/edit']")
        end

        context 'with correct form' do
          subject { click_button '更新' }

          it "updates the roaster's information" do
            click_link 'roaster'
            click_link '編集'
            fill_in '店舗名', with: 'アップデートロースター'
            fill_in '電話番号', with: '0000000000'
            select '大阪府', from: '都道府県'
            fill_in '住所', with: '難波市***-****'
            fill_in '店舗紹介', with: 'アップデートメッセージ'
            subject
            expect(current_path).to eq roaster_path roaster
            expect(page).to have_content 'ロースター情報を更新しました'
            expect(page).to have_content 'アップデートロースター'
            expect(page).to have_content '大阪府'
            expect(page).to have_content '難波市***-****'
            expect(page).to have_content 'アップデートメッセージ'
          end
          pending 'ロースター詳細ページ��電話番号を表示する' do
            expect(page).to have_content '000000000'
          end
        end
      end
    end

    describe 'delete roaster feature' do
      before do
        sign_in user_belonging_a_roaster
        visit root_path
        click_link 'roaster'
        click_link '編集'
        click_link 'ロースターを削除する'
      end

      context 'When user select "OK" in the confirmation' do
        it 'deletes a roaster' do
          expect do
            click_button '削除する'
            accept_confirm
            expect(current_path).to eq home_users_path
          end.to change(Roaster, :count).by(-1)
          expect(page).to have_content "ロースター「#{roaster.name}」を削除しました"
          expect(page).to_not have_selector("a[href='/roasters/#{roaster.id}]")
        end
      end
    end
  end

  describe 'followers page' do
    let(:user) { create(:user) }
    let(:roaster) { create(:roaster) }

    before do
      sign_in user
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
