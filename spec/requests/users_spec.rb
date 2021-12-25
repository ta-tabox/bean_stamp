require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  let(:base_title) { 'BeansApp' }

  context 'when user is signed in' do
    before do
      sign_in user
    end

    describe 'GET #home' do
      it 'gets users/home' do
        get user_home_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ホーム | #{base_title}</title>")
      end
    end

    describe 'GET #show' do
      before do
        get user_path(user)
      end
      it 'gets users/show' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ユーザー詳細 | #{base_title}</title>")
      end
      it 'shows user name' do
        expect(response.body).to include(user.name.to_s)
      end
    end

    describe 'GET #new' do
      it 'regirects to user_home' do
        get new_user_registration_path
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'GET #edit' do
      before do
        get edit_user_registration_path
      end
      it 'gets users/registrations/edit' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ユーザー情報編集 | #{base_title}</title>")
      end
      it 'shows user name' do
        expect(response.body).to include(user.name.to_s)
      end
    end
    describe 'GET #cancel' do
      it 'gets users/registration/cancel' do
        get users_cancel_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>アカウントの削除 | #{base_title}</title>")
      end
    end
    # deviseが提供する以下メソッドについてはテストが困難（paramsにauthenticity_tokenが必要？）
    # 'PUT #update' についてはfeature specでカバー
    # 'DELET #destroy' についてはfeature specでカバー
  end

  context 'when user is signed out' do
    describe 'GET #new' do
      it 'gets users/registrations/new' do
        get new_user_registration_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>サインアップ | #{base_title}</title>")
      end
    end

    describe 'POST #create' do
      context 'with valid parameter' do
        it 'creates a User and redirects to root_path' do
          expect do
            post user_registration_path, params: { user: attributes_for(:user) }
          end.to change(User, :count).by(1)

          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid parameter' do
        it 'does not creates a User and renders users/new' do
          expect do
            post user_registration_path, params: { user: attributes_for(:user, :invalid) }
          end.to_not change(User, :count)

          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>サインアップ | #{base_title}</title>")
        end

        it 'shows a error message' do
          post user_registration_path, params: { user: attributes_for(:user, :invalid) }
          expect(response.body).to include '1 件のエラーが発生したため ユーザー は保存されませんでした'
        end
      end
    end
  end

  # ゲストログイン機能のテスト
  describe 'POST #guest_sign_in' do
    let!(:guest_user) { create(:user, :guest) }
    let!(:guest_roaster) { create(:roaster, :guest) }

    it 'provides of signed in on guest user and redirects to root_path' do
      post users_guest_sign_in_path
      expect(response).to redirect_to(root_path)
      2.times { follow_redirect! }
      expect(response.body).to include 'ゲストユーザーとしてログインしました'
    end
  end
end
