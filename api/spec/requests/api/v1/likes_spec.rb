require 'rails_helper'

RSpec.describe 'Api::V1::Likes', type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, name: '他のユーザー') }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  # お気に入り一覧
  describe 'GET #index' do
    subject { get api_v1_likes_path, headers: auth_tokens }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in and has a like' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得
      before { user.like_offers << offer }

      it 'returns likes had by the user by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['offer']['bean']['name']).to eq user.likes.first.bean.name
        expect(json[0]['offer']['roaster']['name']).to eq user.likes.first.roaster.name
      end
    end
  end

  # お気に入りフィルタリング
  describe 'GET #index with search params' do
    let(:bean) { create(:bean, :with_image_and_tags) }
    let(:offering_offer) { create(:offer, bean: bean) }
    let(:preparing_offer) { create(:offer, :on_preparing, bean: bean) }
    let(:selling_offer) { create(:offer, :on_selling, bean: bean) }
    let(:sold_offer) { create(:offer, :end_of_sales, bean: bean) }
    # ターゲット
    let(:roasting_bean) { create(:bean, :with_image_and_tags, name: 'roasting_bean') }
    let(:roasting_offer) { create(:offer, :on_roasting, bean: roasting_bean) }
    let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

    subject { get api_v1_likes_path, params: { search: status }, headers: auth_tokens }

    before do
      user.like_offers.push(offering_offer, roasting_offer, preparing_offer, selling_offer, sold_offer)
    end

    # ロースト中のお気に入りを検索する
    context 'when search for on_offering' do
      let(:status) { 'on_roasting' }
      it 'returns likes on_roasting by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json[0]['offer']['bean']['name']).to eq roasting_bean.name
      end
    end
  end

  # お気に入り作成
  describe 'POST #create' do
    subject { proc { post offer_likes_path(offer), headers: { 'HTTP_REFERER' => likes_url } } }
    subject { proc { post api_v1_likes_path, params: { like: like_params }, headers: auth_tokens } }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }
      let(:like_params) { { offer_id: offer.id } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得
      let(:like_params) { { offer_id: offer.id } }

      it { is_expected.to change(Like, :count).by(1) }
      it { is_expected.to change(user.likes, :count).by(1) }
      it { is_expected.to change(offer.likes, :count).by(1) }
    end
  end

  # お気に入り削除
  describe 'DELET #destroy' do
    let(:like) { user.likes.find_by(offer_id: offer.id) }
    subject { proc { delete api_v1_like_path(like), headers: auth_tokens } }
    before { user.like_offers << offer }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it { is_expected.to change(Like, :count).by(-1) }
      it { is_expected.to change(user.likes, :count).by(-1) }
      it { is_expected.to change(offer.likes, :count).by(-1) }
    end
  end
end
