require 'rails_helper'

RSpec.describe BeansController, type: :controller do
  let(:user) { create(:user) }
  let(:roaster) { create(:roaster) }
  let(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }

  # ユーザー未ログイン時におけるbeans_controller各アクションへのアクセス制限のテスト
  context 'when user does not sign in' do
    describe 'GET #index' do
      it 'redirects to new_user_session_path' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #show' do
      it 'redirects to new_user_session_path' do
        get :show, params: { id: bean }
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
        post :create, params: { bean: attributes_for(:bean) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to new_user_session_path' do
        get :edit, params: { id: bean }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PUT #update' do
      it 'redirects to new_user_session_path' do
        put :update, params: { id: bean, bean: attributes_for(:bean, :update) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to new_user_session_path' do
        delete :destroy, params: { id: bean }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # ユーザーログイン、ロースター未登録時におけるbeans_controller各アクションへのアクセス制限のテスト
  context 'when user who does not belong roaster is signed in' do
    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'redirects to root_path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #show' do
      it 'redirects to root_path' do
        get :show, params: { id: bean }
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #new' do
      it 'redirects to root_path' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'redirects to root_path' do
        post :create, params: { bean: attributes_for(:bean) }
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to root_path' do
        get :edit, params: { id: bean }
        expect(response).to redirect_to root_path
      end
    end

    describe 'PUT #update' do
      it 'redirects to root_path' do
        put :update, params: { id: bean, bean: attributes_for(:bean, :update) }
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to root_path' do
        delete :destroy, params: { id: bean }
        expect(response).to redirect_to root_path
      end
    end
  end
end
