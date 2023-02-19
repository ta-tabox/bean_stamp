require 'rails_helper'

RSpec.describe 'Api::V1::Beans', type: :request do
  # コーヒー豆を持たないロースターに所属したユーザー
  let(:user_with_no_beans) { create(:user, :with_roaster) }
  # コーヒー豆を持ったロースターに所属したユーザー
  let(:user_with_beans) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: user_with_beans.roaster) }

  # コーヒー豆一覧
  describe 'GET #index' do
    subject { get api_v1_beans_path, headers: auth_tokens }

    context 'when the roaster has no beans' do
      let(:auth_tokens) { sign_in_with_token(user_with_no_beans) }
      it 'returns an empty array by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 0
      end
    end

    context 'when the roaster has a bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_beans) }
      it 'returns beans had by the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.length).to eq 1
        expect(json[0]['name']).to eq bean.name
      end
    end
  end

  # コーヒー豆詳細
  describe 'GET #show' do
    subject { get api_v1_bean_path(bean), headers: auth_tokens }

    context 'when the roaster has not the bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_no_beans) }
      it 'returns error and message by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'コーヒー豆を登録してください'
      end
    end

    context 'when the roaster has the bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_beans) }
      it 'returns beans had by the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq bean.name
      end
    end
  end

  # コーヒー豆作成
  describe 'POST #create' do
    let(:auth_tokens) { sign_in_with_token(user_with_no_beans) }

    subject do
      proc {
        post api_v1_beans_path, params: { bean: bean_params, taste_tag: taste_tag_params, bean_image: attributes_for(:bean_image_params_for_api) },
                                headers: auth_tokens
      }
    end

    shared_examples 'does not create a bean' do
      it { is_expected.not_to change(Bean, :count) }
      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['messages'].first).to eq error_message
      end
    end

    shared_examples 'creates the bean' do
      it { is_expected.to change(Bean, :count).by(1) }
      it 'return the bean by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['id']).to eq Bean.last.id
        expect(json['name']).to eq Bean.last.name
      end
    end

    context 'with valid parameters' do
      # bean_paramsを正常なパラメータで定義する
      let(:bean_params) { attributes_for(:bean) }
      let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }
      it_behaves_like 'creates the bean'
    end

    # bean_paramsに正常ではないパラメータを渡すときのテスト
    context 'with no name' do
      let(:bean_params) { attributes_for(:bean, name: nil) }
      let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }
      let(:error_message) { 'タイトルを入力してください' }

      it_behaves_like 'does not create a bean'
    end

    context 'with no country' do
      let(:bean_params) { attributes_for(:bean, country_id: 0) }
      let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }

      let(:error_message) { '生産国を選択してください' }

      it_behaves_like 'does not create a bean'
    end

    context 'with too much text in describe' do
      let(:bean_params) { attributes_for(:bean, describe: ('a' * 301).to_s) }
      let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }

      let(:error_message) { 'コーヒー紹介は300文字以内で入力してください' }

      it_behaves_like 'does not create a bean'
    end

    context 'with no taste_tags' do
      let(:bean_params) { attributes_for(:bean) }
      let(:taste_tag_params) { { taste_tag_ids: [nil] } }
      let(:error_message) { 'フレーバーを入力してください' }

      it_behaves_like 'does not create a bean'
    end

    context 'with one taste_tag' do
      let(:bean_params) { attributes_for(:bean) }
      let(:taste_tag_params) { { taste_tag_ids: [3] } }

      let(:error_message) { 'Flavorは2つ以上登録してください' }

      it_behaves_like 'does not create a bean'
    end

    context 'with duplication of taste_tags' do
      let(:bean_params) { attributes_for(:bean) }
      let(:taste_tag_params) { { taste_tag_ids: [1, 3, 3] } }

      let(:error_message) { 'Flavorが重複しています' }

      it_behaves_like 'does not create a bean'
    end
  end

  # コーヒー豆更新
  describe 'PUT #update' do
    subject { proc { put api_v1_bean_path(bean), params: { bean: bean_params, taste_tag: taste_tag_params }, headers: auth_tokens } }

    shared_examples 'does not update the bean' do
      it { is_expected.not_to change(Bean.find(bean.id), attribute) }

      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['messages'].first).to eq error_message
      end
    end

    context 'when the roaster has not the bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_no_beans) }
      let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }
      let(:bean_params) { attributes_for(:bean, :update) }

      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'コーヒー豆を登録してください'
      end
    end

    context 'when the roaster has the bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_beans) }

      context 'with valid parameters' do
        # bean_paramsに正常なパラメータを定義する
        let(:bean_params) { attributes_for(:bean, :update) }
        let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }

        it { is_expected.to change { Bean.find(bean.id).name }.from('テストビーン').to('アップデートビーン') }
        it 'return the bean by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json['name']).to eq Bean.find(bean.id).name
        end
      end

      # bean_paramsに正常ではないパラメータを渡すときのテスト
      context 'with no name' do
        let(:bean_params) { attributes_for(:bean, name: nil) }
        let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }
        let(:error_message) { 'タイトルを入力してください' }
        let(:attribute) { :name }

        it_behaves_like 'does not update the bean'
      end

      context 'with no country' do
        let(:bean_params) { attributes_for(:bean, country_id: 0) }
        let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }
        let(:error_message) { '生産国を選択してください' }
        let(:attribute) { :country }

        it_behaves_like 'does not update the bean'
      end

      context 'with too much text in describe' do
        let(:bean_params) { attributes_for(:bean, describe: ('a' * 301).to_s) }
        let(:taste_tag_params) { { taste_tag_ids: [0, 2, 3] } }

        let(:error_message) { 'コーヒー紹介は300文字以内で入力してください' }
        let(:attribute) { :describe }

        it_behaves_like 'does not update the bean'
      end
    end
  end

  # コーヒー豆削除
  describe 'DELETE #destroy' do
    subject { proc { delete api_v1_bean_path(bean), headers: auth_tokens } }

    context 'when the roaster has not the bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_no_beans) }
      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json['messages'].first).to eq 'コーヒー豆を登録してください'
      end
    end

    context 'when the roaster has the bean' do
      let(:auth_tokens) { sign_in_with_token(user_with_beans) }

      context 'with no offers' do
        it { is_expected.to change(Bean, :count).by(-1) }
        it 'returns success and message by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:success)
          expect(json).to include('messages')
        end
      end

      context 'with a offer' do
        let!(:offer) { create(:offer, bean: bean) }

        it { is_expected.not_to change(Bean, :count) }
        it 'returns error and message by json' do
          subject.call
          json = JSON.parse(response.body)
          expect(response).to have_http_status(:method_not_allowed)
          expect(json['messages'].first).to eq 'コーヒー豆はオファー中です'
        end
      end
    end
  end
end
