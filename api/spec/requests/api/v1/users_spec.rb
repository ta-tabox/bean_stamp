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

  # TODO: レスポンスのJSONの構造を変更する {data: xxx}
  describe 'GET #roasters_followed_by_user' do
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

  describe 'GET #current_offers', focus: true do
    subject { get current_offers_api_v1_users_path, headers: auth_tokens }

    context 'when a user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when a user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) }
      let!(:bean) { create(:bean, :with_image_and_tags, roaster: roaster_with_offer) }
      let!(:offer) { create(:offer, bean: bean) }
      let!(:roaster_with_offer) { create(:roaster) }
      let!(:roaster_with_no_offers) { create(:roaster) }

      context 'when the user has following roaster with no offers' do
        before do
          user.following_roasters << roaster_with_no_offers
        end
        it 'returns an empty array by json' do
          subject
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json.length).to eq 0
        end
      end
      context 'when the user has following roaster with offer' do
        before do
          user.following_roasters << roaster_with_offer
        end

        it 'returns offers had by the roaster by json' do
          subject
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json.length).to eq 1
          expect(json[0]['roasted_at']).to eq offer.roasted_at.strftime('%Y-%m-%d')
          expect(json[0]['roaster']['name']).to eq roaster_with_offer.name
        end
      end
    end
  end
end
