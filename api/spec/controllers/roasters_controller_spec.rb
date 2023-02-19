require 'rails_helper'

RSpec.describe RoastersController, type: :controller, skip: true do
  let(:roaster) { create(:roaster) }

  # ユーザー未ログイン時におけるroasters_controller各アクションへのアクセス制限のテスト
  context 'when a user is not signed in' do
    describe 'GET #index' do
      it 'redirects to new_user_session_path' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #show' do
      it 'redirects to new_user_session_path' do
        get :show, params: { id: roaster.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #new' do
      it 'redirects to new_user_session_path' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'redirects to new_user_session_path' do
        post :create, params: { roaster: attributes_for(:roaster) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to new_user_session_path' do
        get :edit, params: { id: roaster.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PUT #update' do
      it 'redirects to new_user_session_path' do
        put :update, params: { id: roaster.id, roaster: attributes_for(:roaster, :update) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to new_user_session_path' do
        delete :destroy, params: { id: roaster.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #cancel' do
      it 'redirects to new_user_session_path' do
        get :cancel, params: { id: roaster.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #followers' do
      it 'redirects to new_user_session_path' do
        get :followers, params: { id: roaster.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
