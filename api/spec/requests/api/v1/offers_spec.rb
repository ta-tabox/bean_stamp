require 'rails_helper'

RSpec.describe 'Api::V1::Offers', type: :request do
  # ロースターに所属しないユーザー
  let(:user) { create(:user) }
  # コーヒー豆、オファーを持たないロースターに所属したユーザー
  let(:user_without_beans_and_offers) { create(:user, :with_roaster) }
  # オファー付きのコーヒー豆を持ったロースターに所属したユーザー
  let(:user_with_a_offer) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  # オファー一覧
  describe 'GET #index' do
    subject { get api_v1_offers_path, headers: auth_tokens }
    context 'when the roaster has no offers' do
      let(:auth_tokens) { sign_in_with_token(user_without_beans_and_offers) }
      it 'returns an empty array by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 0
      end
    end
    context 'when the roaster has a offer' do
      let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }

      it 'returns offers had by the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['roasted_at']).to eq offer.roasted_at.strftime('%Y-%m-%d')
      end
    end
  end

  # オファーフィルタリング
  describe 'GET #index with status params' do
    subject { get api_v1_offers_path, params: { search: status }, headers: auth_tokens }

    let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }
    let(:bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster) }
    let!(:offering_offer) { create(:offer, bean: bean) }
    let!(:preparing_offer) { create(:offer, :on_preparing, bean: bean) }
    let!(:selling_offer) { create(:offer, :on_selling, bean: bean) }
    let!(:sold_offer) { create(:offer, :end_of_sales, bean: bean) }
    # ターゲット
    let!(:roasting_bean) { create(:bean, :with_image_and_tags, name: 'roasting_bean', roaster: user_with_a_offer.roaster) }
    let!(:roasting_offer) { create(:offer, :on_roasting, bean: roasting_bean) }

    # ロースト中のウォンツをsearch
    context 'when search for on_roasting' do
      let(:status) { 'on_roasting' }
      it 'returns offers on_roasting by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['roasted_at']).to eq roasting_offer.roasted_at.strftime('%Y-%m-%d')
      end
    end
  end

  # オファー情報取得
  describe 'GET #show' do
    subject { get api_v1_offer_path(offer), headers: auth_tokens }

    shared_examples 'success' do
      it 'returns a offer by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['roasted_at']).to eq offer.roasted_at.strftime('%Y-%m-%d')
      end
    end

    context 'when the user does not belong to a roaster' do
      let(:auth_tokens) { sign_in_with_token(user) }
      it_behaves_like 'success'
    end

    context 'when the user belongs to a roaster who had no offers' do
      let(:auth_tokens) { sign_in_with_token(user_without_beans_and_offers) }
      it_behaves_like 'success'
    end

    context 'when a user belongs to a roaster who had a offer' do
      let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }
      it_behaves_like 'success'
    end
  end

  # オファー作成
  describe 'POST #create' do
    subject { proc { post api_v1_offers_path, params: { offer: offer_params }, headers: auth_tokens } }

    shared_examples 'does not create a offer' do
      it { is_expected.not_to change(Offer, :count) }
      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['messages'].first).to eq error_message
      end
    end

    context 'when the user has no beans' do
      let(:auth_tokens) { sign_in_with_token(user_without_beans_and_offers) }
      let(:offer_params) { attributes_for(:offer, bean_id: bean.id) }

      it 'returns not_found and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'コーヒー豆を登録してください'
      end
    end

    context 'when the user has a bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }

      # offer_paramsに正常なパラメータを渡す時のテスト
      context 'with valid parameter' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id) }
        it { is_expected.to change(Offer, :count).by(1) }
        it 'return the offer by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json['roasted_at']).to eq offer.roasted_at.strftime('%Y-%m-%d')
        end
      end

      # offer_paramsに正常ではないパラーメータを渡す時のテスト
      context 'with no ended_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, ended_at: nil) }
        let(:error_message) { 'オファー終了日を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with no roasted_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, roasted_at: nil) }
        let(:error_message) { '焙煎日を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with no receit_started_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, receipt_started_at: nil) }
        let(:error_message) { '受け取り開始日を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with no receipt_ended_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, receipt_ended_at: nil) }
        let(:error_message) { '受け取り終了日を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with no price' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, price: nil) }
        let(:error_message) { '販売価格を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with price of strings' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, price: 'price') }
        let(:error_message) { '販売価格は数値で入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with no weight' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, weight: nil) }
        let(:error_message) { '内容量を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with weight of strings' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, weight: 'weight') }
        let(:error_message) { '内容量は数値で入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with no amount' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, amount: nil) }
        let(:error_message) { '数量を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'with amount of strings' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, amount: 'amount') }
        let(:error_message) { '数量は数値で入力してください' }
        it_behaves_like 'does not create a offer'
      end

      # 日���データの順番をテストする
      context 'when the roasterd_at is earlier than the ended_at' do
        let(:offer_params) { attributes_for(:offer, :too_early_roasted_at, bean_id: bean.id) }
        let(:error_message) { '焙煎日はオファー終了日以降の日付を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'when the receipt_started_at is earlier than the roasterd_at' do
        let(:offer_params) { attributes_for(:offer, :too_early_receipt_started_at, bean_id: bean.id) }
        let(:error_message) { '受け取り開始日は焙煎日以降の日付を入力してください' }
        it_behaves_like 'does not create a offer'
      end

      context 'when the receipt_ended_at is earlier than the receipt_started_at' do
        let(:offer_params) { attributes_for(:offer, :too_early_receipt_ended_at, bean_id: bean.id) }
        let(:error_message) { '受け取り終了日は受け取り開始日以降の日付を入力してください' }
        it_behaves_like 'does not create a offer'
      end
    end
  end

  # オファー更新
  describe 'PUT #update' do
    subject { proc { put api_v1_offer_path(offer), params: { offer: offer_params }, headers: auth_tokens } }

    shared_examples 'does not update the offer' do
      it { is_expected.not_to change(Offer.find(offer.id), attribute) }
      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['messages'].first).to eq error_message
      end
    end

    context 'when a user has no beans' do
      let(:auth_tokens) { sign_in_with_token(user_without_beans_and_offers) }
      let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id) }

      it 'returns not_found and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'オファーを登録してください'
      end
    end

    context 'when a user has a bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }

      # offer_paramsに正常なパラメータを渡す時のテスト
      context 'with valid parameter' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id) }
        it { is_expected.to change { Offer.find(offer.id).price }.from(1000).to(1500) }
        it 'return the offer by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json['roasted_at']).to eq offer.roasted_at.strftime('%Y-%m-%d')
        end
      end

      # offer_paramsに正常ではないパラーメータを渡す時のテスト
      context 'with no ended_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, ended_at: nil) }
        let(:error_message) { 'オファー終了日を入力してください' }
        let(:attribute) { :ended_at }
        it_behaves_like 'does not update the offer'
      end

      context 'with no roasted_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, roasted_at: nil) }
        let(:error_message) { '焙煎日を入力してください' }
        let(:attribute) { :roasted_at }
        it_behaves_like 'does not update the offer'
      end

      context 'with no receit_started_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, receipt_started_at: nil) }
        let(:error_message) { '受け取り開始日を入力してください' }
        let(:attribute) { :receipt_started_at }
        it_behaves_like 'does not update the offer'
      end

      context 'with no receipt_ended_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, receipt_ended_at: nil) }
        let(:error_message) { '受け取り終了日を入力してください' }
        let(:attribute) { :receipt_ended_at }
        it_behaves_like 'does not update the offer'
      end

      context 'with no price' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, price: nil) }
        let(:error_message) { '販売価格を入力してください' }
        let(:attribute) { :price }
        it_behaves_like 'does not update the offer'
      end

      context 'with price of strings' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, price: 'price') }
        let(:error_message) { '販売価格は数値で入力してください' }
        let(:attribute) { :price }
        it_behaves_like 'does not update the offer'
      end

      context 'with no weight' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, weight: nil) }
        let(:error_message) { '内容量を入力してください' }
        let(:attribute) { :weight }
        it_behaves_like 'does not update the offer'
      end

      context 'with weight of strings' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, weight: 'weight') }
        let(:error_message) { '内容量は数値で入力してください' }
        let(:attribute) { :weight }
        it_behaves_like 'does not update the offer'
      end

      context 'with no amount' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, amount: nil) }
        let(:error_message) { '数量を入力してください' }
        let(:attribute) { :amount }
        it_behaves_like 'does not update the offer'
      end

      context 'with amount of strings' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, amount: 'amount') }
        let(:error_message) { '数量は数値で入力してください' }
        let(:attribute) { :amount }
        it_behaves_like 'does not update the offer'
      end
    end
  end

  # オファー削除
  describe 'DELETE #destory' do
    subject { proc { delete api_v1_offer_path(offer), headers: auth_tokens } }

    context 'when the user have no offers' do
      let(:auth_tokens) { sign_in_with_token(user_without_beans_and_offers) }

      it { is_expected.not_to change(Offer, :count) }
      it 'returns not_found and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'オファーを登録してください'
      end
    end

    context 'when the user has the offer' do
      let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }

      it { is_expected.to change(Offer, :count).by(-1) }
      it 'deletes the offer' do
        subject.call
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # オファ���に��ォン��したユーザー一覧
  describe 'GET #wanted_users' do
    let(:wanted_user) { create(:user) }

    subject { get wanted_users_api_v1_offer_path(offer), headers: auth_tokens }
    before do
      offer.wanted_users << wanted_user
    end

    context 'when the user is not signed in' do
      let(:auth_tokens) { { 'client' => '', 'access-token' => '', 'uid' => '' } }
      it 'redirects to new_user_session_path ' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is not belonging to a roaster' do
      let(:auth_tokens) { sign_in_with_token(user) }

      it 'returns error and message by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:method_not_allowed)
        expect(json['messages'].first).to eq 'ロースターを登録をしてください'
      end
    end

    context 'when the user does not have the offer' do
      let(:another_user) { create(:user, roaster: another_roaster) }
      let(:another_roaster) { create(:roaster) }
      let(:auth_tokens) { sign_in_with_token(another_user) }

      it 'returns not_found and message by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'オファーを登録してください'
      end
    end

    context 'when the user is belonging to a roaster with the offer' do
      let(:auth_tokens) { sign_in_with_token(user_with_a_offer) }

      it 'returns users who wanted to the offer by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['name']).to eq wanted_user.name
      end
    end
  end
end
