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
      # FactoryBotにてtaste_tagsとbean_imagesのパラメータを作成（他にいいやり方あるか？）
      subject { post beans_path, params: { bean: bean_params, bean_images: attributes_for(:bean_image_params) } }

      context 'with valid parameter' do
        # bean_paramsを正常なパラメータで定義する
        let(:bean_params) { attributes_for(:bean, :with_taste_tags_params) }

        it 'creates a Bean and redirects to bean_path' do
          expect { subject }.to change(Bean, :count).by(1)
          # Beanは default_scope -> { order(created_at: :desc) }のためBean.firstで最新のレコードを取得する
          expect(response).to redirect_to bean_path(Bean.first)
        end
      end

      context 'with invalid parameter' do
        # bean_paramsを正常ではないパラメータで定義する
        let(:bean_params) { attributes_for(:bean, :invalid, :with_taste_tags_params) }
        it 'does not create a Bean and redirects to beans_path' do
          expect { subject }.to_not change(Bean, :count)
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>コーヒー豆登録#{base_title}</title>")
        end

        it 'shows a error message' do
          subject
          expect(response.body).to include '1 件のエラーが発生したため コーヒー豆 は保存されませんでした'
        end
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
      subject { put bean_path bean, params: { bean: bean_params } }

      context 'with valid parameter' do
        # bean_paramsに正常なパラメータを定義する
        let(:bean_params) { attributes_for(:bean, :update) }

        it 'updates the bean and redirect_to bean_path' do
          expect { subject }.to change { Bean.find(bean.id).name }.from('テストビーン').to('アップデートビーン')
          expect(response).to redirect_to bean_path bean
        end
      end

      context 'with invalid parameter' do
        # bean_paramsに正常ではないパラメータを定義する
        let(:bean_params) { attributes_for(:bean, :invalid) }

        it 'does not updated the bean and renders beans/edit' do
          expect { subject }.to_not change(Bean.find(bean.id), :name)
          expect(response).to have_http_status(:success)
          expect(response.body).to include("<title>コーヒー豆情報編集#{base_title}</title>")
        end

        it 'shows a error message' do
          subject
          expect(response.body).to include '1 件のエラーが発生したため コーヒー豆 は保存されませんでした'
        end
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
