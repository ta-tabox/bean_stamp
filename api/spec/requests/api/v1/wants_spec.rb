require 'rails_helper'

RSpec.describe 'Api::V1::Wants', type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, name: '他のユーザー') }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  # ウォンツ一覧
  describe 'GET #index' do
    subject { get api_v1_wants_path, headers: auth_tokens }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in and has a want' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得
      before { user.want_offers << offer }

      it 'returns wants had by the user by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['offer']['bean']['name']).to eq user.wants.first.bean.name
        expect(json[0]['offer']['roaster']['name']).to eq user.wants.first.roaster.name
      end
    end
  end

  # ウォンツフィルタリング
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

    subject { get api_v1_wants_path, params: { search: status }, headers: auth_tokens }

    before do
      user.want_offers.push(offering_offer, roasting_offer, preparing_offer, selling_offer, sold_offer)
    end

    # ロースト中のウォンツを検索する
    context 'when search for on_offering' do
      let(:status) { 'on_roasting' }
      it 'returns wants on_roasting by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json[0]['offer']['bean']['name']).to eq roasting_bean.name
      end
    end
  end

  # ウォンツ詳細
  describe 'GET #show' do
    let(:want) { create(:want, user_id: user.id, offer_id: offer.id) }
    subject { get api_v1_want_path(want), headers: auth_tokens }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user does not have a want' do
      let(:auth_tokens) { sign_in_with_token(another_user) } # ログインとトークンの取得

      it 'returns not_found and message by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'ウォンツが見つかりません'
      end
    end

    context 'when the user has a want' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it 'returns want had by the user by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['user_id']).to eq want.user_id
        expect(json['offer']['bean']['name']).to eq want.bean.name
        expect(json['offer']['roaster']['name']).to eq want.roaster.name
      end
    end
  end

  # ウォンツ作成
  describe 'POST #create' do
    subject { proc { post api_v1_wants_path, params: { want: want_params }, headers: auth_tokens } }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }
      let(:want_params) { { offer_id: offer.id } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得
      let(:want_params) { { offer_id: offer.id } }

      it { is_expected.to change(Want, :count).by(1) }
      it {
        is_expected.to change(user.wants, :count).by(1)
      }
      it { is_expected.to change(offer.wants, :count).by(1) }

      # wantがoffer.amountの上限に達していたらwantを作成しない
      context 'when an offer reached the max amount' do
        let(:offer_reached_max_amount) { create(:offer, amount: 1, bean: bean) }
        let(:want_params) { { offer_id: offer_reached_max_amount.id } }

        before do
          offer_reached_max_amount.wanted_users << another_user
        end
        it { is_expected.to_not change(Want, :count) }
        it 'returns method_not_allowed and message by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:method_not_allowed)
          expect(json['messages'].first).to eq '数量が上限に達しています'
        end
      end

      # 本日がoffer.ended_at当日だったらwantを作成する
      context 'when today is offer ended at day' do
        let(:offer_ended_at_today) { create(:offer, ended_at: Date.current, bean: bean) }
        let(:want_params) { { offer_id: offer_ended_at_today.id } }

        it { is_expected.to change(Want, :count).by(1) }
      end

      # 本日がoffer.ended_at以降の日だったらwantを作成しない
      context 'when today is after an offer ended at day' do
        let(:offer_ended_at_yesterday) { create(:offer, :on_roasting, bean: bean) }
        let(:want_params) { { offer_id: offer_ended_at_yesterday.id } }

        it { is_expected.to_not change(Want, :count) }
        it 'returns method_not_allowed and message by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:method_not_allowed)
          expect(json['messages'].first).to eq 'オファーは終了しました'
        end
      end
    end
  end

  # ウォンツ削除
  describe 'DELET #destroy' do
    let(:want) { user.wants.find_by(offer_id: offer.id) }
    subject { proc { delete api_v1_want_path(want), headers: auth_tokens } }
    before { user.want_offers << offer }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is signed in' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it { is_expected.to change(Want, :count).by(-1) }
      it { is_expected.to change(user.wants, :count).by(-1) }
      it { is_expected.to change(offer.wants, :count).by(-1) }
    end
  end

  # 受け取り完了
  describe 'PATCH #receipt' do
    let(:want) { create(:want, user_id: user.id, offer_id: offer.id) }
    subject { proc { patch receipt_api_v1_want_path(want), headers: auth_tokens } }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user does not have a want' do
      let(:auth_tokens) { sign_in_with_token(another_user) } # ログインとトークンの取得

      it 'returns not_found and message by json' do
        subject.call
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user have a want' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it { is_expected.to change { Want.find(want.id).receipted_at? }.from(false).to(true) }

      # すでに受け取り済みの場合、２重で受け取り処理ができないことをテスト
      context 'when the user already received' do
        before do
          want.update(receipted_at: Time.current.prev_day(1))
        end
        it { is_expected.to_not(change { Want.find(want.id).receipted_at }) }
        it 'returns method_not_allowed and message by json' do
          subject.call
          expect(response).to have_http_status(:method_not_allowed)
        end
      end
    end
  end

  # 評価
  describe 'PATCH #rate' do
    let(:want) { create(:want, user_id: user.id, offer_id: offer.id) }
    subject { proc { patch rate_api_v1_want_path(want), params: { want: { rate: 'good' } }, headers: auth_tokens } }

    context 'when the user is signed out' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }

      it 'returns status of unauthorized' do
        subject.call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user does not have a want' do
      let(:auth_tokens) { sign_in_with_token(another_user) } # ログインとトークンの取得

      it 'returns not_found and message by json' do
        subject.call
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user have a want' do
      let(:auth_tokens) { sign_in_with_token(user) } # ログインとトークンの取得

      it { is_expected.to change { Want.find(want.id).rate }.from('unrated').to('good') }

      # すでに評価済みの場合は評価できないことをテスト
      context 'when the user already received' do
        before { want.so_so! }
        it { is_expected.to_not(change { Want.find(want.id).rate }) }
      end
    end
  end
end
