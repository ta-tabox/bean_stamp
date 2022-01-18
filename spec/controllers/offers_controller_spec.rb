require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:user) { create(:user) }
  let(:roaster) { create(:roaster) }
  let(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let(:offer) { create(:offer, bean: bean) }

  # ユーザー未ログイン時におけるoffers_controller各アクションへのアクセス制限のテスト
  context 'when user does not sign in' do
    describe 'GET #index' do
      it 'redirects to new_user_session_path' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #show' do
      it 'redirects to new_user_session_path' do
        get :show, params: { id: offer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #new' do
      it 'redirects to new_user_session_path' do
        get :new, params: { bean_id: bean.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'redirects to new_user_session_path' do
        post :create, params: { offer: attributes_for(:offer) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to new_user_session_path' do
        get :edit, params: { id: offer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PUT #update' do
      it 'redirects to new_user_session_path' do
        put :update, params: { id: offer.id, offer: attributes_for(:offer, :update) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to new_user_session_path' do
        delete :destroy, params: { id: offer.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # ユーザーログイン、ロースター未登録時におけるoffers_controller各アクションへのアクセス制限のテスト
  # showのみ許可
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
        get :show, params: { id: offer.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET #new' do
      it 'redirects to root_path' do
        get :new, params: { bean_id: bean.id }
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'redirects to root_path' do
        post :create, params: { offer: attributes_for(:offer) }
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to root_path' do
        get :edit, params: { id: offer.id }
        expect(response).to redirect_to root_path
      end
    end

    describe 'PUT #update' do
      it 'redirects to root_path' do
        put :update, params: { id: offer.id, offer: attributes_for(:offer, :update) }
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to root_path' do
        delete :destroy, params: { id: offer.id }
        expect(response).to redirect_to root_path
      end
    end
  end
end
