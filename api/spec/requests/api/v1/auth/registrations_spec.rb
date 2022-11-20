require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Registrations', type: :request do
  let(:user) { create(:user) }

  describe 'POST #create' do
    subject { proc { post api_v1_user_registration_path, params: user_params } }

    context 'when a user is signed out' do
      shared_examples 'does not create a User' do
        it { is_expected.to_not change(User, :count) }
        it {
          subject.call
          expect(response).to have_http_status(:unprocessable_entity)
        }
      end

      context 'with valid parameter' do
        let(:user_params) { attributes_for(:user) }

        it { is_expected.to change(User, :count).by(1) }
        it {
          subject.call
          expect(response).to have_http_status(:success)
        }
      end

      context 'with no name' do
        let(:user_params) { attributes_for(:user, name: nil) }

        it_behaves_like 'does not create a User'
      end

      context 'with no email' do
        let(:user_params) { attributes_for(:user, email: nil) }

        it_behaves_like 'does not create a User'
      end

      context 'with existing email address' do
        before { user }
        let(:user_params) { attributes_for(:user, email: user.email) }

        it_behaves_like 'does not create a User'
      end

      context 'with mismatching passwords' do
        let(:user_params) { attributes_for(:user, password: 'password', password_confirmation: 'mismatching_password') }

        it_behaves_like 'does not create a User'
      end

      context 'with too less password' do
        let(:user_params) { attributes_for(:user, password: 'pswd', password_confirmation: 'pswd') }

        it_behaves_like 'does not create a User'
      end
    end
  end
end
