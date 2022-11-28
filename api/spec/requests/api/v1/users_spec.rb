require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET #show' do
    subject { get api_v1_user_path(user), headers: auth_tokens }

    context 'when a user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when a user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) }

      it 'returns a user' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq user.name
        expect(json['describe']).to eq user.describe
      end
    end
  end

  describe 'GET # roasters_followed_by_user' do
    let(:roaster) { create(:roaster) }

    subject { get roasters_followed_by_user_api_v1_user_path(user), headers: auth_tokens }

    before do
      user.following_roasters << roaster
    end

    context 'when a user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when a user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) }

      it 'returns array of roasters' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['name']).to eq roaster.name
      end
    end
  end
end
