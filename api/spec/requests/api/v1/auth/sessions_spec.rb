require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Sessions', type: :request do
  let!(:roaster) { create(:roaster) }
  let(:user_belonging_to_the_roaster) { create(:user, roaster: roaster) }
  let(:user_not_belonging_to_the_roaster) { create(:user) }

  describe 'GET /index' do
    subject { get api_v1_auth_sessions_path, headers: auth_tokens }

    context 'when a user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns is_login: false' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['is_login']).to be_falsey
      end
    end

    context 'when a user is signed in' do
      context 'with no roaster' do
        # tokenによるログイン処理
        let(:auth_tokens) { sign_in_with_token(user_not_belonging_to_the_roaster) }
        it 'returns is_login: true, signed_in user and no roaster' do
          subject
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json['is_login']).to be_truthy
          expect(json.dig('user', 'name')).to eq user_not_belonging_to_the_roaster.name
          expect(json['roaster']).to eq nil
        end
      end

      context 'with roaster' do
        # tokenによるログイン処理
        let(:auth_tokens) { sign_in_with_token(user_belonging_to_the_roaster) }
        it 'returns is_login: true, signed_in user, current roaster' do
          subject
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json['is_login']).to be_truthy
          expect(json.dig('user', 'name')).to eq user_belonging_to_the_roaster.name
          expect(json.dig('roaster', 'name')).to eq roaster.name
        end
      end
    end
  end
end
