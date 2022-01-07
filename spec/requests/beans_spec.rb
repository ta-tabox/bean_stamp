require 'rails_helper'

RSpec.describe 'Beans', type: :request do
  let(:base_title) { ' | BeansApp' }
  # コーヒー豆を持たないロースターに所属したユーザー
  let(:user_without_beans) { create(:user, :with_roaster) }
  # コーヒー豆を持ったロースターに所属したユーザー
  let(:user_with_beans) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: user_with_beans.roaster) }

  # コーヒー豆を持っていないときのテスト
  context 'when a roaster have no beans' do
    before do
      sign_in user_without_beans
    end

    describe 'GET #index' do
      it 'gets beans/index' do
        get beans_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>コーヒー豆一覧#{base_title}</title>")
        expect(response.body).not_to include(bean.name)
      end
    end

    describe 'GET #show' do
      it 'redirects to beans_path' do
        get bean_path bean
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'コーヒー豆を登録してください'
      end
    end

    describe 'GET #new' do
      it 'gets beans/new' do
        get new_bean_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>コーヒー豆登録#{base_title}</title>")
      end
    end

    describe 'POST #create' do
      # FactoryBotにてbean_imagesのパラメータを作成
      subject {  proc { post beans_path, params: { bean: bean_params, bean_images: attributes_for(:bean_image_params) } } }

      shared_examples 'does not create a Bean and redirects to beans_path' do
        it { is_expected.not_to change(Bean, :count) }
        it {
          subject.call
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>コーヒー豆登録#{base_title}</title>")
        }
      end

      shared_examples 'shows a error message' do
        it {
          subject.call
          expect(response.body).to include error_message
        }
      end

      context 'with valid parameter' do
        # bean_paramsを正常なパラメータで定義する
        let(:bean_params) { attributes_for(:bean, bean_taste_tags_attributes: { '0' => { mst_taste_tag_id: '2' }, '1' => { mst_taste_tag_id: '3' } }) }

        it { is_expected.to change(Bean, :count).by(1) }
        it {
          subject.call
          # Beanは default_scope -> { order(created_at: :desc) }のためBean.firstで最新のレコードを取得する
          expect(response).to redirect_to bean_path(Bean.first)
        }
      end

      # bean_paramsに正常ではないパラメータを渡すときのテスト
      context 'with no name' do
        let(:bean_params) { attributes_for(:bean, name: nil) }
        let(:error_message) { 'タイトルを入力してください' }

        it_behaves_like 'does not create a Bean and redirects to beans_path'
        it_behaves_like 'shows a error message'
      end

      context 'with no country' do
        let(:bean_params) { attributes_for(:bean, country: nil) }
        let(:error_message) { '生産国を入力してください' }

        it_behaves_like 'does not create a Bean and redirects to beans_path'
        it_behaves_like 'shows a error message'
      end

      context 'with too much text in describe' do
        let(:bean_params) { attributes_for(:bean, describe: ('a' * 301).to_s) }
        let(:error_message) { 'コーヒー紹介は300文字以内で入力してください' }

        it_behaves_like 'does not create a Bean and redirects to beans_path'
        it_behaves_like 'shows a error message'
      end

      context 'with no taste_tags' do
        let(:bean_params) { attributes_for(:bean) }
        let(:error_message) { 'Tastesは2つ以上登録してください' }

        it_behaves_like 'does not create a Bean and redirects to beans_path'
        it_behaves_like 'shows a error message'
      end

      context 'with one taste_tag' do
        let(:bean_params) { attributes_for(:bean, bean_taste_tags_attributes: { '0' => { mst_taste_tag_id: '2' } }) }
        let(:error_message) { 'Tastesは2つ以上登録してください' }

        it_behaves_like 'does not create a Bean and redirects to beans_path'
        it_behaves_like 'shows a error message'
      end

      context 'with duplication of taste_tags' do
        let(:bean_params) { attributes_for(:bean, bean_taste_tags_attributes: { '0' => { mst_taste_tag_id: '2' }, '1' => { mst_taste_tag_id: '2' } }) }
        let(:error_message) { 'Tastesが重複しています' }

        it_behaves_like 'does not create a Bean and redirects to beans_path'
        it_behaves_like 'shows a error message'
      end
    end

    describe 'GET #edit' do
      it 'redirects to beans_path' do
        get edit_bean_path bean
        expect(response).to redirect_to(beans_path)
        follow_redirect!
        expect(response.body).to include 'コーヒー豆を登録してください'
      end
    end

    describe 'PUT #update' do
      it 'does not update a Bean and redirects to beans_path' do
        expect do
          put bean_path bean, params: { bean: attributes_for(:bean, :update) }
        end.to_not change(Bean.find(bean.id), :name)
        expect(response).to redirect_to beans_path
      end
    end

    describe 'DELETE #destory' do
      it 'does not delete a Bean and redirects to beans_path' do
        expect { delete bean_path bean }.not_to change(Bean, :count)
        expect(response).to redirect_to(beans_path)
      end
    end
  end

  # コーヒー豆を持っているときのテスト
  context 'when a roaster have a bean' do
    before do
      sign_in user_with_beans
    end

    describe 'GET #index' do
      it "gets beans/index and shows the bean's name" do
        get beans_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>コーヒー豆一覧#{base_title}</title>")
        expect(response.body).to include(bean.name)
      end
    end

    describe 'GET #show' do
      it "gets beans/show and shows the bean's name" do
        get bean_path bean
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>コーヒー豆詳細#{base_title}</title>")
        expect(response.body).to include(bean.name)
      end
    end

    # GET #new, GET #crateはコーヒー豆の有無で挙動が変わらないためテストしない

    describe 'GET #edit' do
      before do
        get edit_bean_path bean
      end
      it 'gets beans/edit' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>コーヒー豆情報編集#{base_title}</title>")
      end
      it "shows bean's name" do
        expect(response.body).to include(bean.name)
      end
    end

    describe 'PUT #update' do
      subject { proc { put bean_path bean, params: { bean: bean_params } } }

      shared_examples 'does not updated the bean and renders beans/edit' do
        it { is_expected.not_to change(Bean.find(bean.id), attribute) }
        it {
          subject.call
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>コーヒー豆情報編集#{base_title}</title>")
        }
      end

      shared_examples 'shows a error message' do
        it {
          subject.call
          expect(response.body).to include error_message
        }
      end

      context 'with valid parameter' do
        # bean_paramsに正常なパラメータを定義する
        let(:bean_params) { attributes_for(:bean, :update) }

        it { is_expected.to change { Bean.find(bean.id).name }.from('テストビーン').to('アップデートビーン') }
        it {
          subject.call
          expect(response).to redirect_to bean_path bean
        }
      end

      # bean_paramsに正常ではないパラメータを渡すときのテスト
      context 'with no name' do
        let(:bean_params) { attributes_for(:bean, name: nil) }
        let(:error_message) { 'タイトルを入力してください' }
        let(:attribute) { :name }

        it_behaves_like 'does not updated the bean and renders beans/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no country' do
        let(:bean_params) { attributes_for(:bean, country: nil) }
        let(:error_message) { '生産国を入力してください' }
        let(:attribute) { :country }

        it_behaves_like 'does not updated the bean and renders beans/edit'
        it_behaves_like 'shows a error message'
      end

      context 'with too much text in describe' do
        let(:bean_params) { attributes_for(:bean, describe: ('a' * 301).to_s) }
        let(:error_message) { 'コーヒー紹介は300文字以内で入力してください' }
        let(:attribute) { :describe }

        it_behaves_like 'does not updated the bean and renders beans/edit'
        it_behaves_like 'shows a error message'
      end
    end

    describe 'DELETE #destory' do
      it 'deletes a Bean and redirects to beans_path' do
        expect { delete bean_path bean }.to change(Bean, :count).by(-1)
        expect(response).to redirect_to beans_path
      end
    end
  end
end
