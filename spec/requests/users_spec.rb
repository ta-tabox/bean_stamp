require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:base_title) { ' | BeansApp' }
  let(:user) { create(:user) }

  describe 'GET #home' do
    subject { get user_home_path }

    context 'when user is signed out' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is signed in' do
      before { sign_in user }
      it 'gets users/home' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ホーム#{base_title}</title>")
      end
    end
  end

  describe 'GET #show' do
    subject { get user_path user }

    context 'when user is signed out' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is signed in' do
      before { sign_in user }
      it 'gets users/show' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ユーザー詳細#{base_title}</title>")
      end

      it "shows user's name and describe" do
        subject
        expect(response.body).to include(user.name.to_s)
        expect(response.body).to include(user.describe.to_s)
      end
    end
  end

  describe 'GET #new' do
    subject { get new_user_registration_path }

    context 'when user is signed out' do
      it 'gets users/registrations/new' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>サインアップ#{base_title}</title>")
      end
    end

    context 'when user is signed in' do
      before { sign_in user }
      it { is_expected.to redirect_to root_path }
    end
  end

  describe 'POST #create' do
    subject { proc { post user_registration_path, params: { user: user_params } } }

    context 'when user is signed out' do
      shared_examples 'does not create a User and renders users/new' do
        it { is_expected.to_not change(User, :count) }
        it {
          subject.call
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>サインアップ#{base_title}</title>")
        }
      end

      shared_examples 'shows a error message' do
        it {
          subject.call
          expect(response.body).to include error_message
        }
      end

      context 'with valid parameter' do
        let(:user_params) { attributes_for(:user) }

        it { is_expected.to change(User, :count).by(1) }
        it {
          subject.call
          expect(response).to redirect_to root_path
        }
      end

      context 'with no name' do
        let(:user_params) { attributes_for(:user, name: nil) }
        let(:error_message) { '名前を入力してください' }

        it_behaves_like 'does not create a User and renders users/new'
        it_behaves_like 'shows a error message'
      end

      context 'with no email' do
        let(:user_params) { attributes_for(:user, email: nil) }
        let(:error_message) { 'Eメールを入力してください' }

        it_behaves_like 'does not create a User and renders users/new'
        it_behaves_like 'shows a error message'
      end

      context 'with existing email address' do
        before { user }
        let(:user_params) { attributes_for(:user, email: user.email) }
        let(:error_message) { 'Eメールはすでに存在します' }

        it_behaves_like 'does not create a User and renders users/new'
        it_behaves_like 'shows a error message'
      end

      context 'with mismatching passwords' do
        let(:user_params) { attributes_for(:user, password: 'password', password_confirmation: 'mismatching_password') }
        let(:error_message) { 'パスワードの入力が一致しません' }

        it_behaves_like 'does not create a User and renders users/new'
        it_behaves_like 'shows a error message'
      end

      context 'with too less password' do
        let(:user_params) { attributes_for(:user, password: 'pswd', password_confirmation: 'pswd') }
        let(:error_message) { 'パスワードは6文字以上で入力してください' }

        it_behaves_like 'does not create a User and renders users/new'
        it_behaves_like 'shows a error message'
      end
    end

    context 'when user is signed in' do
      let(:user_params) { attributes_for(:user) }
      before { sign_in user }
      it {
        subject.call
        expect(response).to redirect_to root_path
      }
    end
  end

  describe 'GET #edit' do
    subject { get edit_user_registration_path }

    context 'when user is signed out' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is signed in' do
      before { sign_in user }

      it 'gets users/registrations/edit' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ユーザー情報編集#{base_title}</title>")
      end
      it 'shows user name' do
        subject
        expect(response.body).to include(user.name.to_s)
      end
    end
  end

  describe 'GET #cancel' do
    subject { get cancel_user_registration_path }

    context 'when user is signed out' do
      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user is signed in' do
      before { sign_in user }
      it 'gets users/registration/cancel' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>アカウントの削除#{base_title}</title>")
      end
    end
  end

  # deviseが提供する以下メソッドについてはテストが困難（paramsにauthenticity_tokenが必要？）
  # 'PUT #update' についてはfeature specでカバー
  # 'DELET #destroy' についてはfeature specでカバー

  # ゲストログイン機能のテスト
  describe 'POST #guest_sign_in' do
    let!(:guest_user) { create(:user, :guest) }
    let!(:guest_roaster) { create(:roaster, :guest) }

    it 'provides of signed in on guest user and redirects to root_path' do
      post users_guest_sign_in_path
      expect(response).to redirect_to root_path
      # follow_redirect!1回目→302、2回目→200レスポンスが返ってくる
      2.times { follow_redirect! }
      expect(response.body).to include 'ゲストユーザーとしてログインしました'
    end
  end
end
