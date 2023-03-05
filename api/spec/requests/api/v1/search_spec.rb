require 'rails_helper'

RSpec.describe 'Api::V1::Search' do
  let(:user) { create(:user) }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'GET #roaster' do
    subject { get api_v1_search_roasters_path, headers: auth_tokens }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it 'returns roasters by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['name']).to eq roaster.name
      end
    end
  end

  describe 'GET #offer' do
    subject { get api_v1_search_offers_path, headers: auth_tokens }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it 'returns offers by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['bean']['name']).to eq offer.bean.name
        expect(json[0]['roaster']['name']).to eq offer.roaster.name
      end
    end
  end
end
