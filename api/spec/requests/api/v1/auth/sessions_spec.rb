require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Sessions', type: :request, focus: true do
  let(:user) { create(:user) }

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
      # tokenによるログイン処理
      let(:auth_tokens) { sign_in_with_token(user) }
      it 'returns is_login: true and signed_in user' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['is_login']).to be_truthy
        expect(json.dig('data', 'name')).to eq user.name
      end
    end
  end
end
