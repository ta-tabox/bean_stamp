require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, name: '他のテストユーザー') }

  describe 'User CRUD' do
    context 'when user is not signed in' do
      before { visit root_path }

      describe 'new registration feature' do
        subject { proc { click_button '登録' } }

        before do
          click_link 'メールアドレスで登録'
          fill_in '名前', with: 'テストユーザー'
          fill_in 'Eメール', with: 'test@example.com'
          select '広島県', from: 'エリア'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認用）', with: 'password'
        end

        context 'with correct form' do
          it 'creates a new user' do
            is_expected.to change(User, :count).by(1)
            expect(current_path).to eq home_users_path
            expect(page).to have_content 'アカウント登録が完了しました'
          end
        end
      end

      describe 'sign in feature' do
        subject { click_button 'ログイン' }

        before do
          click_link 'ログイン'
          fill_in 'Eメール', with: user.email
          fill_in 'パスワード', with: user.password
        end

        context 'with correct form' do
          it 'creates a new session' do
            subject
            expect(current_path).to eq home_users_path
            expect(page).to have_content 'ログインしました'
          end
        end

        context 'with no email' do
          it 'does not create a new session' do
            fill_in 'Eメール', with: nil
            subject
            expect(current_path).to eq new_user_session_path
            expect(page).to have_content 'Eメールまたはパスワードが違います'
          end
        end

        context 'with wrong password' do
          it 'does not create a new session' do
            fill_in 'パスワード', with: 'wrong_password'
            subject
            expect(current_path).to eq new_user_session_path
            expect(page).to have_content 'Eメールまたはパスワードが違います'
          end
        end
      end
    end

    context 'when user is signed in' do
      before do
        sign_in user
        visit root_path
      end

      describe 'user editing feature' do
        subject { click_button '更新' }
        before do
          click_link 'User'
          click_link '編集'
        end

        context 'with correct form without password' do
          it 'updates the user information' do
            fill_in '名前', with: 'アップデートユーザー'
            fill_in 'Eメール', with: 'update@example.com'
            select '東京都', from: 'エリア'
            fill_in '自己紹介', with: 'テストメッセージ'
            subject
            expect(current_path).to eq user_path user
            expect(page).to have_content 'アカウント情報を変更しました。'
            expect(page).to have_content 'アップデートユーザー'
            expect(page).to have_content '東京都'
            expect(page).to have_content 'テストメッセージ'
          end
        end

        context 'with a image' do
          it 'uploads a image' do
            attach_file 'user[image]', Rails.root.join('spec/fixtures/sample.jpg')
            subject
            expect(current_path).to eq user_path user
            expect(page).to have_content 'アカウント情報を変更しました。'
            expect(page).to have_selector("img[src$='sample.jpg']")
          end
        end

        context 'with no name' do
          it 'does not update the user information' do
            fill_in '名前', with: nil
            subject
            expect(current_path).to eq user_registration_path
            expect(page).to have_content '名前を入力してください'
          end
        end

        context 'with no email' do
          it 'does not update the user information' do
            fill_in 'Eメール', with: nil
            subject
            expect(current_path).to eq user_registration_path
            expect(page).to have_content 'Eメールを入力してください'
          end
        end

        context 'with too much text in describe' do
          it 'does not update the user information' do
            fill_in '自己紹介', with: ('a' * 141).to_s
            subject
            expect(current_path).to eq user_registration_path
            expect(page).to have_content '140文字まで投稿'
          end
        end

        describe 'change password feature' do
          before do
            fill_in '現在のパスワード', with: user.password
            fill_in 'パスワード', with: 'new_password'
            fill_in 'パスワード（確認用）', with: 'new_password'
          end

          context 'with correct password' do
            it 'updates a new password' do
              subject
              expect(current_path).to eq user_path user
              expect(page).to have_content 'アカウント情報を変更しました。'
            end
          end

          context 'with no current password' do
            it 'does not update a new password' do
              fill_in '現在のパスワード', with: nil
              subject
              expect(current_path).to eq user_registration_path
              expect(page).to have_content '現在のパスワードを入力してください'
            end
          end

          context 'with wrong password' do
            it 'does not update a new password' do
              fill_in 'パスワード', with: 'wrong_password'
              subject
              expect(current_path).to eq user_registration_path
              expect(page).to have_content 'パスワードの入力が一致しません'
            end
          end
        end
      end

      describe 'user detail showing feature' do
        subject { visit user_path user }

        context 'when log in as user' do
          it "shows user's name" do
            subject
            expect(page).to have_content user.name
          end

          it 'displays a edit button' do
            subject
            expect(page).to have_content '編集'
            expect(page).to have_selector("a[href='/users/edit']")
          end
        end

        context 'when log in as another user' do
          before { sign_in another_user }
          it "shows user's name" do
            subject
            expect(page).to have_content user.name
          end
          it 'does not display a edit button' do
            subject
            expect(page).to_not have_content '編集'
            expect(page).to_not have_selector("a[href='/users/edit']")
          end
        end
      end

      describe 'user member canceling feature' do
        before do
          visit edit_user_registration_path
          click_link '退会する'
        end
        context 'When user select "OK" in the confirmation' do
          it 'deletes a user account' do
            expect do
              click_button '退会する'
              accept_confirm
              expect(current_path).to eq root_path
              expect(page).to have_content 'アカウントを削除しました'
            end.to change(User, :count).by(-1)
          end
        end
      end
    end
  end
end
