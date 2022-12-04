require 'rails_helper'

RSpec.describe 'Api::V1::Roasters', type: :request do
  let!(:roaster) { create(:roaster) }
  let(:user_belonging_to_the_roaster) { create(:user, roaster: roaster) }
  let(:user_not_belonging_to_the_roaster) { create(:user) }

  # ロースター詳細
  describe 'GET #show' do
    subject { get api_v1_roaster_path(roaster), headers: auth_tokens }

    shared_examples 'return the roaster' do
      it 'returns the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq roaster.name
        expect(json['describe']).to eq roaster.describe
      end
    end

    context 'when a user does not belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_not_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end

    context 'when a user belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end
  end

  # ロースター作成
  describe 'POST #create' do
    subject { proc { post api_v1_roasters_path, params: { roaster: roaster_params }, headers: auth_tokens } }

    shared_examples 'does not create a roaster' do
      it { is_expected.not_to change(Roaster, :count) }
      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['status']).to eq 'error'
        expect(json['messages'].first).to eq error_message
      end
    end

    shared_examples 'creates the roaster' do
      it { is_expected.to change(Roaster, :count).by(1) }
      it 'return the roaster by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.dig('data', 'name')).to eq roaster.name # NOTE: 同じattributeを使用しているので結果的にイコールになるが、あまり適切ではない
      end
    end

    context 'when a user have already belonged to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_belonging_to_the_roaster) }
      let(:roaster_params) { attributes_for(:roaster) }

      it { is_expected.not_to change(Roaster, :count) }
      it 'returns error and message by json' do
        subject.call
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['status']).to eq 'error'
        expect(json['message']).to eq 'ロースターをすでに登録しています'
      end
    end

    context 'when a user does not belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_not_belonging_to_the_roaster) }

      # 正常なパラメーターを渡す
      context 'with valid parameters' do
        let(:roaster_params) { attributes_for(:roaster) }

        it_behaves_like 'creates the roaster'
      end

      # 正常ではないパラメーターを渡す
      context 'with invalid parameters' do
        context 'no name' do
          let(:roaster_params) { attributes_for(:roaster, name: nil) }
          let(:error_message) { '店舗名を入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'no phone_number' do
          let(:roaster_params) { attributes_for(:roaster, phone_number: nil) }
          let(:error_message) { '電話番号を入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'too less integer' do
          let(:roaster_params) { attributes_for(:roaster, phone_number: '123456789') }
          let(:error_message) { '電話番号は10文字以上で入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'too much integer' do
          let(:roaster_params) { attributes_for(:roaster, phone_number: '123456789123') }
          let(:error_message) { '電話番号は11文字以内で入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'multiple strings' do
          let(:roaster_params) { attributes_for(:roaster, phone_number: '11文字の電話番号です') }
          let(:error_message) { '電話番号は数値で入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'no prefecture_code' do
          let(:roaster_params) { attributes_for(:roaster, prefecture_code: nil) }
          let(:error_message) { '都道府県を入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'no address' do
          let(:roaster_params) { attributes_for(:roaster, address: nil) }
          let(:error_message) { '住所を入力してください' }

          it_behaves_like 'does not create a roaster'
        end

        context 'too much text in describe' do
          let(:roaster_params) { attributes_for(:roaster, describe: ('a' * 301).to_s) }
          let(:error_message) { '店舗紹介は300文字以内で入力してください' }

          it_behaves_like 'does not create a roaster'
        end
      end
    end
  end

  # TODO: update, destroy, followersのテスト
  describe 'PUT #update' do
    subject { get api_v1_roaster_path(roaster), headers: auth_tokens }

    shared_examples 'return the roaster' do
      it 'returns the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq roaster.name
        expect(json['describe']).to eq roaster.describe
      end
    end

    context 'when a user does not belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_not_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end

    context 'when a user belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end
  end

  describe 'DELETE #destroy' do
    subject { get api_v1_roaster_path(roaster), headers: auth_tokens }

    shared_examples 'return the roaster' do
      it 'returns the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq roaster.name
        expect(json['describe']).to eq roaster.describe
      end
    end

    context 'when a user does not belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_not_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end

    context 'when a user belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end
  end

  describe 'GET #followers' do
    subject { get api_v1_roaster_path(roaster), headers: auth_tokens }

    shared_examples 'return the roaster' do
      it 'returns the roaster by json' do
        subject
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq roaster.name
        expect(json['describe']).to eq roaster.describe
      end
    end

    context 'when a user does not belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_not_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end

    context 'when a user belong to the roaster' do
      let(:auth_tokens) { sign_in_with_token(user_belonging_to_the_roaster) }

      it_behaves_like 'return the roaster'
    end
  end
end
