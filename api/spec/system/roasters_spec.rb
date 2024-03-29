require 'rails_helper'

RSpec.describe 'Roasters', type: :system, skip: true do
  describe 'Roaster CRUD' do
    let(:roaster) { create(:roaster, :with_image) }
    let(:another_roaster) { create(:roaster, :with_image, name: '他のテストロースター') }
    let(:user_not_belonging_a_roaster) { create(:user) }
    let(:user_belonging_a_roaster) { create(:user, roaster: roaster) }
    let(:user_belonging_an_another_roaster) { create(:user, roaster: another_roaster) }

    describe 'new registration feature', js: true do
      subject { proc { click_button '登録' } }

      context 'when user is not belonging to a roaster' do
        before do
          sign_in user_not_belonging_a_roaster
          visit edit_user_registration_path
        end

        before do
          click_link 'ロースターとして登録する'
          fill_in '店舗名', with: 'テストロースター'
          fill_in '電話番号', with: '0123456789'
          find('#roaster_prefecture_code').select '東京都'
          fill_in '住所', with: '渋谷区***-****'
          find('#roaster_describe').fill_in with: 'テストメッセージ'
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
            expect(page).to have_selector("img[src*='sample.jpg']")
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
          expect(page).to have_content roaster.phone_number
          expect(page).to have_content roaster.describe
          expect(page).to have_selector("img[src*='sample.jpg']")
        }
      end

      context 'when user is not belonging to a roaster' do
        before do
          sign_in user_not_belonging_a_roaster
        end

        it_behaves_like "shows roaster's informations"

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

        it 'shows an offer and does not show edit and delete link' do
          subject
          expect(page).to have_content bean.name
          expect(page).to have_selector("a[href='/offers/#{offer.id}']")
          expect(page).to_not have_selector("a[href='/offers/#{offer.id}/edit']")
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

    describe 'roaster editing feature', js: true do
      context 'when user is belonging to a roaseter' do
        before do
          sign_in user_belonging_a_roaster
          visit root_path
        end

        it 'does not desplay link for /roasters/new but /roasters/[:id]/edit in users/edit' do
          click_link 'User'
          click_link '編集'
          expect(page).to_not have_selector("a[href='/roasters/new']")
          expect(page).to have_selector("a[href='/roasters/#{roaster.id}/edit']")
        end

        context 'with correct form' do
          subject { click_button '更新' }

          it "updates the roaster's information" do
            visit home_roasters_path
            click_link 'Roaster'
            click_link '編集'
            fill_in '店舗名', with: 'アップデートロースター'
            fill_in '電話番号', with: '0000000000'
            find('#roaster_prefecture_code').select '大阪府'
            fill_in '住所', with: '難波市***-****'
            find('#roaster_describe').fill_in with: 'アップデートメッセージ'
            subject
            expect(current_path).to eq roaster_path roaster
            expect(page).to have_content 'ロースター情報を更新しました'
            expect(page).to have_content 'アップデートロースター'
            expect(page).to have_content '大阪府'
            expect(page).to have_content '難波市***-****'
            expect(page).to have_content 'アップデートメッセージ'
            expect(page).to have_content '000000000'
          end
        end
      end
    end

    describe 'delete roaster feature', js: true do
      before do
        sign_in user_belonging_a_roaster
        visit home_roasters_path
        click_link 'Roaster'
        click_link '編集'
        click_link '削除する'
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

  describe 'Roaster#home' do
    let(:user) { create(:user, roaster: roaster) }
    let(:roaster) { create(:roaster) }

    before do
      sign_in user
      visit home_users_path
    end

    context 'with side-toggle' do
      it 'toggle user to roasters/home and navs' do
        click_link 'side-toggle'
        expect(page).to have_selector("a[href='/roasters/home']")
        expect(page).to have_selector("a[href='/roasters/#{roaster.id}']")
        expect(page).to have_selector("a[href='/beans']")
        expect(page).to have_selector("a[href='/offers']")
        expect(page).to have_selector("a[href='/users/home']")
        click_link 'side-toggle'
        expect(page).to have_selector("a[href='/users/home']")
        expect(page).to have_selector("a[href='/users/#{user.id}']")
        expect(page).to have_selector("a[href='/users/#{user.id}/following']")
        expect(page).to have_selector("a[href='/wants']")
        expect(page).to have_selector("a[href='/users/sign_out']")
        # expect(page).to have_selector("a[href='/likes']")
        # expect(page).to have_selector("a[href='/search']")
      end
    end
  end
end
