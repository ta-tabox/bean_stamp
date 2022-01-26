require 'rails_helper'

RSpec.describe 'Roasters', type: :request do
  let(:base_title) { ' | BeansApp' }
  let!(:roaster) { create(:roaster) }
  let(:user_belonging_a_roaster) { create(:user, roaster: roaster) }
  let(:user_not_belonging_a_roaster) { create(:user) }

  # ロースター未登録の場合のテスト
  context 'when a user is not belonging to the roaster' do
    before do
      sign_in user_not_belonging_a_roaster
    end

    describe 'GET #index' do
      it 'gets roasters/index' do
        get roasters_path
        expect(response).to have_http_status(:success)
        skip 'roaster/indexのタイトル' do
          # roaster/indexのタイトルを決めたらテストする（search機能実装時）
          expect(response.body).to include("<title>#{base_title}</title>")
        end
      end
    end

    describe 'GET #show' do
      it 'gets roasters/show' do
        get roaster_path roaster
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ロースター詳細#{base_title}</title>")
      end
    end

    describe 'GET #new' do
      it 'gets roasters/new' do
        get new_roaster_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ロースター登録#{base_title}</title>")
      end
    end

    describe 'POST #create' do
      subject { proc { post roasters_path, params: { roaster: roaster_params } } }

      shared_examples 'does not create a Raster and redirects to root_path' do
        it { is_expected.not_to change(Roaster, :count) }
        it {
          subject.call
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>ロースター登録#{base_title}</title>")
        }
      end

      shared_examples 'shows a error message' do
        it {
          subject.call
          expect(response.body).to include error_message
        }
      end

      context 'with valid parameter' do
        # roater_paramsに正常なパラメータを定義する
        let(:roaster_params) { attributes_for(:roaster) }

        it { is_expected.to change(Roaster, :count).by(1) }
        it {
          subject.call
          expect(response).to redirect_to roaster_path(Roaster.last)
        }
      end

      # rotaster_paramsに正常ではないパラメータを渡すときのテスト
      context 'with no name' do
        let(:roaster_params) { attributes_for(:roaster, name: nil) }
        let(:error_message) { '店舗名を入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with no phone_number' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: nil) }
        let(:error_message) { '電話番号を入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with too less integer' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: '123456789') }
        let(:error_message) { '電話番号は10文字以上で入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with too much integer' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: '123456789123') }
        let(:error_message) { '電話番号は11文字以内で入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with multiple strings' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: '11文字の電話番号です') }
        let(:error_message) { '電話番号は数値で入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with no prefecture_code' do
        let(:roaster_params) { attributes_for(:roaster, prefecture_code: nil) }
        let(:error_message) { '都道府県を入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with no address' do
        let(:roaster_params) { attributes_for(:roaster, address: nil) }
        let(:error_message) { '住所を入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end

      context 'with too much text in describe' do
        let(:roaster_params) { attributes_for(:roaster, describe: ('a' * 301).to_s) }
        let(:error_message) { '店舗紹介は300文字以内で入力してください' }

        it_behaves_like 'does not create a Raster and redirects to root_path'
        it_behaves_like 'shows a error message'
      end
    end

    describe 'GET #edit' do
      it 'redirects to root_path ' do
        get edit_roaster_path roaster
        expect(response).to redirect_to root_path
      end
    end

    describe 'PUT #update' do
      it 'redirects to root_path ' do
        put roaster_path roaster, params: { roaster: attributes_for(:roaster, :update) }
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to root_path ' do
        expect { delete roaster_path roaster }.not_to change(Roaster, :count)
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #cancel' do
      it 'redirects to root_path ' do
        get cancel_roasters_path
        expect(response).to redirect_to root_path
      end
    end
  end

  # ロースター登録済みの場合のテスト
  context 'when a user is belonging to the roaster' do
    before do
      sign_in user_belonging_a_roaster
    end

    describe 'GET #index' do
      it 'gets roasters/index' do
        get roasters_path
        expect(response).to have_http_status(:success)
        skip 'roaster/indexのタイトル' do
          # roaster/indexのタイトルを決めたらテストする（search機能実装時）
          expect(response.body).to include("<title>#{base_title}</title>")
        end
      end
    end

    describe 'GET #show' do
      it 'gets roasters/show' do
        get roaster_path roaster
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ロースター詳細#{base_title}</title>")
      end
    end

    describe 'GET #new' do
      it 'redirects to root_path' do
        get new_roaster_path
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'does not create a Roaster and redirect_to root_path' do
        expect do
          post roasters_path, params: { roaster: attributes_for(:roaster) }
        end.to_not change(Roaster, :count)
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      before do
        get edit_roaster_path roaster
      end
      it 'gets roasters/edit' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ロースター情報編集#{base_title}</title>")
      end
      it "shows roaster's name" do
        expect(response.body).to include(roaster.name)
      end
    end

    describe 'PUT #update' do
      subject { proc { put roaster_path roaster, params: { roaster: roaster_params } } }
      shared_examples 'does not updated the roaster and renders roasters/edit' do
        it { is_expected.not_to change(Roaster.find(roaster.id), :name) }
        it {
          subject.call
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>ロースター情報編集#{base_title}</title>")
        }
      end

      shared_examples 'shows a error message' do
        it {
          subject.call
          expect(response.body).to include error_message
        }
      end

      context 'with valid parameter' do
        # roaster_parasmに正常なパラメータを定義する
        let(:roaster_params) { attributes_for(:roaster, :update) }

        it { is_expected.to change { Roaster.find(roaster.id).name }.from('テストロースター').to('アップデートロースター') }
        it {
          subject.call
          expect(response).to redirect_to roaster_path roaster
        }
      end

      # rotaster_paramsに正常ではないパラメータを渡すときのテスト
      context 'with no name' do
        let(:roaster_params) { attributes_for(:roaster, name: nil) }
        let(:error_message) { '店舗名を入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no phone_number' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: nil) }
        let(:error_message) { '電話番号を入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with too less integer' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: '123456789') }
        let(:error_message) { '電話番号は10文字以上で入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with too much integer' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: '123456789123') }
        let(:error_message) { '電話番号は11文字以内で入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with multiple strings' do
        let(:roaster_params) { attributes_for(:roaster, phone_number: '11文字の電話番号です') }
        let(:error_message) { '電話番号は数値で入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no prefecture_code' do
        let(:roaster_params) { attributes_for(:roaster, prefecture_code: nil) }
        let(:error_message) { '都道府県を入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no address' do
        let(:roaster_params) { attributes_for(:roaster, address: nil) }
        let(:error_message) { '住所を入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with too much text in describe' do
        let(:roaster_params) { attributes_for(:roaster, describe: ('a' * 301).to_s) }
        let(:error_message) { '店舗紹介は300文字以内で入力してください' }

        it_behaves_like 'does not updated the roaster and renders roasters/edit'
        it_behaves_like 'shows a error message'
      end
    end

    describe 'DELETE #destory' do
      it 'deletes a Roaster and redirects to root_path' do
        expect { delete roaster_path roaster }.to change(Roaster, :count).by(-1)
        expect(response).to redirect_to user_home_path
      end
    end

    describe 'GET #cancel' do
      it 'gets roasters/cancel' do
        get cancel_roasters_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>ロースターの削除#{base_title}</title>")
        expect(response.body).to include("ロースター(#{roaster.name})の削除を行います")
      end
    end
  end

  # ユーザーが別のロースターに所属していた場合のテスト
  context 'when a user is belonging to another roaster' do
    let(:another_roaster) { create(:roaster, name: '別のロースター') }
    let(:user_belonging_another_roaster) { create(:user, roaster: another_roaster) }

    before do
      sign_in user_belonging_another_roaster
    end

    describe 'GET #show' do
      it 'gets roasters/show' do
        get roaster_path roaster
        expect(response).to have_http_status(:success)
        expect(response.body).to include(roaster.name)
      end
    end

    describe 'GET #edit' do
      it 'redirects to roaster_path' do
        get edit_roaster_path roaster
        expect(response).to redirect_to roaster
      end
    end

    describe 'PUT #update' do
      it 'redirects to roaster_path' do
        put roaster_path roaster, params: { roaster: attributes_for(:roaster, :update) }
        expect(response).to redirect_to roaster
        follow_redirect!
        expect(response.body).to include('所属していないロースターの更新・削除はできません')
      end
    end

    describe 'DELETE #destory' do
      it 'redirects to roaster_path ' do
        expect { delete roaster_path roaster }.not_to change(Roaster, :count)
        expect(response).to redirect_to roaster
        follow_redirect!
        expect(response.body).to include('所属していないロースターの更新・削除はできません')
      end
    end
  end

  # ゲストロースター編集、削除のテスト ensure_normal_roaster
  context 'when the guest user is signed in' do
    let!(:guest_user) { create(:user, :guest, roaster: guest_roaster) }
    let!(:guest_roaster) { create(:roaster, :guest) }

    before do
      sign_in guest_user
    end

    describe 'POST #update' do
      it 'does not updated the guest roaster and redirects to root_path' do
        expect do
          put roaster_path guest_roaster, params: { roaster: attributes_for(:roaster, :update) }
        end.to_not change(Roaster.find(guest_roaster.id), :name)
        expect(response).to redirect_to root_path
        # follow_redirect!1回目→302、2回目→200レスポンスが返ってくる
        2.times { follow_redirect! }
        expect(response.body).to include 'ゲストロースターの更新・削除はできません'
      end
    end

    describe 'DELETE #destroy' do
      it 'does not delete the guest roaster and redirects to root_path' do
        expect do
          delete roaster_path guest_roaster
        end.to_not change(Roaster, :count)
        expect(response).to redirect_to root_path
        # follow_redirect!1回目→302、2回目→200レスポンスが返ってくる
        2.times { follow_redirect! }
        expect(response.body).to include 'ゲストロースターの更新・削除はできません'
      end
    end
  end
end
