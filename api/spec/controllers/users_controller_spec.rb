require 'rails_helper'

RSpec.describe Users::UsersController, type: :controller, skip: true do
  let(:user) { create(:user) }

  # ユーザー未ログイン時におけるusers/users_controller各アクションへのアクセス制限のテスト
  context 'when a user is not signed in' do
    describe 'GET #home' do
      it 'redirects to new_user_session_path' do
        get :home
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #show' do
      it 'redirects to new_user_session_path' do
        get :show, params: { id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #following' do
      it 'redirects to new_user_session_path' do
        get :following, params: { id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
