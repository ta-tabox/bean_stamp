require 'rails_helper'

RSpec.describe 'Api::V1::RoasterRelationships', type: :request do
  let(:user) { create(:user) }
  let(:roaster) { create(:roaster) }
  let(:relationship) { user.roaster_relationships.find_by(roaster_id: roaster.id) }

  shared_examples 'returns json' do
    it 'returns success' do
      subject.call
      expect(response).to have_http_status(:success)
    end

    it "returns user's following roasters count" do
      subject.call
      updated_user = User.find(user.id) # 更新後のユーザーを取得

      json = JSON.parse(response.body)
      expect(json.dig('user', 'following_roasters_count')).to eq updated_user.following_roasters.length
    end

    it "returns roaster's follower count" do
      subject.call
      updated_roaster = Roaster.find(roaster.id) # 更新後のロースターを取得

      json = JSON.parse(response.body)
      expect(json.dig('roaster', 'followers_count')).to eq updated_roaster.followers.length
    end
  end

  describe 'POST #create' do
    subject { proc { post api_v1_roaster_relationships_path, params: { roaster_id: roaster.id }, headers: auth_tokens } }

    context 'when user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it { is_expected.to change(RoasterRelationship, :count).by(1) }
      it { is_expected.to change(user.following_roasters, :count).by(1) }
      it { is_expected.to change(roaster.followers, :count).by(1) }
      it_behaves_like 'returns json'
    end
  end

  describe 'DELET #destroy' do
    subject { proc { delete api_v1_roaster_relationship_path(relationship), headers: auth_tokens } }
    before do
      user.following_roasters << roaster
    end

    context 'when user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it { is_expected.to change(RoasterRelationship, :count).by(-1) }
      it { is_expected.to change(user.following_roasters, :count).by(-1) }
      it { is_expected.to change(roaster.followers, :count).by(-1) }
      it_behaves_like 'returns json'
    end
  end
end
