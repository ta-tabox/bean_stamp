require 'rails_helper'

RSpec.describe 'Offers', type: :request do
  let(:base_title) { ' | BeansApp' }
  # ロースターに所属しないユーザー
  let(:user) { create(:user) }
  # コーヒー豆、オファーを持たないロースターに所属したユーザー
  let(:user_without_beans_and_offers) { create(:user, :with_roaster) }

  # オファー付きのコーヒー豆を持ったロースターに所属したユーザー
  let(:user_with_a_offer) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'GET #index' do
    subject { get offers_path }
    context 'when a user has no offers' do
      before { sign_in user_without_beans_and_offers }
      it 'gets offers/index with no offers' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to eq user_without_beans_and_offers.roaster.id.to_s
        expect(response.body).to include("<title>オファー一覧#{base_title}</title>")
        expect(response.body).not_to include(offer.bean.name)
      end
    end
    context 'when a user has a offer' do
      before { sign_in user_with_a_offer }
      it 'gets offers/index with a offer' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to eq user_with_a_offer.roaster.id.to_s
        expect(response.body).to include("<title>オファー一覧#{base_title}</title>")
        expect(response.body).to include(offer.bean.name)
      end
    end
  end

  describe 'GET #show' do
    subject { get offer_path offer }
    context 'when a user does not belong to a roaster' do
      before { sign_in user }
      it "gets offers/show and shows the bean's name of the offer" do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to be_falsey
        expect(response.body).to include("<title>オファー詳細#{base_title}</title>")
      end
    end
    context 'when a user belongs to a roaster who had no offers' do
      before { sign_in user_without_beans_and_offers }
      it "gets offers/show and shows the bean's name of the offer" do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to be_falsey
        expect(response.body).to include("<title>オファー詳細#{base_title}</title>")
      end
    end
    context 'when a user belongs to a roaster who had a offer' do
      before { sign_in user_with_a_offer }
      it "gets offers/show and shows the bean's name of the offer" do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to be_falsey
        expect(response.body).to include("<title>オファー詳細#{base_title}</title>")
      end
    end
  end

  describe 'GET #new' do
    subject { get new_offer_path, params: { bean_id: bean.id } }
    context 'when a user has no beans' do
      before { sign_in user_without_beans_and_offers }
      it 'redirects to beans_path' do
        subject
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'コーヒー豆を登録してください'
      end
    end
    context 'when a user has a bean' do
      before { sign_in user_with_a_offer }
      it 'gets offers/new' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to eq user_with_a_offer.roaster.id.to_s
        expect(response.body).to include("<title>オファー作成#{base_title}</title>")
      end
    end
  end

  describe 'POST #create' do
    subject { proc { post offers_path, params: { offer: offer_params } } }

    shared_examples 'does not create a Offer and renders to new' do
      it { is_expected.not_to change(Offer, :count) }
      it {
        subject.call
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>オファー作成#{base_title}</title>")
      }
    end

    shared_examples 'shows a error message' do
      it {
        subject.call
        expect(response.body).to include error_message
      }
    end

    context 'when a user has no beans' do
      before { sign_in user_without_beans_and_offers }
      let(:offer_params) { attributes_for(:offer, bean_id: bean.id) }

      it 'redirects to beans_path' do
        subject.call
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'コーヒー豆を登録してください'
      end
    end

    context 'when a user has a bean' do
      before { sign_in user_with_a_offer }

      # offer_paramsに正常なパラメータを渡す時のテスト
      context 'with valid parameter' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id) }
        it { is_expected.to change(Offer, :count).by(1) }
        it {
          subject.call
          expect(response).to redirect_to offer_path(Offer.last)
        }
      end

      # offer_paramsに正常ではないパラーメータを渡す時のテスト
      context 'with no ended_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, ended_at: nil) }
        let(:error_message) { 'オファー終了日を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with no roasted_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, roasted_at: nil) }
        let(:error_message) { '焙煎日を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with no receit_started_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, receipt_started_at: nil) }
        let(:error_message) { '受け取り開始日を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with no receipt_ended_at' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, receipt_ended_at: nil) }
        let(:error_message) { '受け取り終了日を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with no price' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, price: nil) }
        let(:error_message) { '販売価格を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with price of strings' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, price: 'price') }
        let(:error_message) { '販売価格は数値で入力' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with no weight' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, weight: nil) }
        let(:error_message) { '内容量を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with weight of strings' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, weight: 'weight') }
        let(:error_message) { '内容量は数値で入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with no amount' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, amount: nil) }
        let(:error_message) { '数量を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'with amount of strings' do
        let(:offer_params) { attributes_for(:offer, bean_id: bean.id, amount: 'amount') }
        let(:error_message) { '数量は数値で入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      # 日付データの順番をテストする
      context 'when the roasterd_at is earlier than the ended_at' do
        let(:offer_params) { attributes_for(:offer, :too_early_roasted_at, bean_id: bean.id) }
        let(:error_message) { '焙煎日はオファー終了日以降の日付を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'when the receipt_started_at is earlier than the roasterd_at' do
        let(:offer_params) { attributes_for(:offer, :too_early_receipt_started_at, bean_id: bean.id) }
        let(:error_message) { '受け取り開始日は焙煎日以降の日付を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

      context 'when the receipt_ended_at is earlier than the receipt_started_at' do
        let(:offer_params) { attributes_for(:offer, :too_early_receipt_ended_at, bean_id: bean.id) }
        let(:error_message) { '受け取り終了日は受け取り開始日以降の日付を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end
    end
  end

  describe 'GET #edit' do
    subject { get edit_offer_path offer }
    context 'when a user has no offers' do
      before { sign_in user_without_beans_and_offers }
      it 'gets offers/edit' do
        subject
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'オファーを登録してください'
      end
    end
    context 'when a user has a offer' do
      before { sign_in user_with_a_offer }
      it 'gets offers/edit' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to eq user_with_a_offer.roaster.id.to_s
        expect(response.body).to include("<title>オファー編集#{base_title}</title>")
      end
    end
  end

  describe 'PUT #update' do
    subject { proc { put offer_path offer, params: { offer: offer_params } } }

    shared_examples 'does not update a Offer and renders to edit' do
      it { is_expected.not_to change(Offer.find(offer.id), attribute) }
      it {
        subject.call
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>オファー編集#{base_title}</title>")
      }
    end

    shared_examples 'shows a error message' do
      it {
        subject.call
        expect(response.body).to include error_message
      }
    end

    context 'when a user has no beans' do
      before { sign_in user_without_beans_and_offers }
      let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id) }

      it 'redirects to beans_path' do
        subject.call
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'オファーを登録してください'
      end
    end

    context 'when a user has a bean' do
      before { sign_in user_with_a_offer }

      # offer_paramsに正常なパラメータを渡す時のテスト
      context 'with valid parameter' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id) }
        it { is_expected.to change { Offer.find(offer.id).price }.from(1000).to(1500) }
        it {
          subject.call
          expect(response).to redirect_to offer_path(offer)
        }
      end

      # offer_paramsに正常ではないパラーメータを渡す時のテスト
      context 'with no ended_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, ended_at: nil) }
        let(:error_message) { 'オファー終了日を入力してください' }
        let(:attribute) { :ended_at }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no roasted_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, roasted_at: nil) }
        let(:error_message) { '焙煎日を入力してください' }
        let(:attribute) { :roasted_at }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no receit_started_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, receipt_started_at: nil) }
        let(:error_message) { '受け取り開始日を入力してください' }
        let(:attribute) { :receipt_started_at }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no receipt_ended_at' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, receipt_ended_at: nil) }
        let(:error_message) { '受け取り終了日を入力してください' }
        let(:attribute) { :receipt_ended_at }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no price' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, price: nil) }
        let(:error_message) { '販売価格を入力してください' }
        let(:attribute) { :price }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with price of strings' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, price: 'price') }
        let(:error_message) { '販売価格は数値で入力してください' }
        let(:attribute) { :price }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no weight' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, weight: nil) }
        let(:error_message) { '内容量を入力してください' }
        let(:attribute) { :weight }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with weight of strings' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, weight: 'weight') }
        let(:error_message) { '内容量は数値で入力してください' }
        let(:attribute) { :weight }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with no amount' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, amount: nil) }
        let(:error_message) { '数量を入力してください' }
        let(:attribute) { :amount }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end

      context 'with amount of strings' do
        let(:offer_params) { attributes_for(:offer, :update, bean_id: bean.id, amount: 'amount') }
        let(:error_message) { '数量は数値で入力してください' }
        let(:attribute) { :amount }

        it_behaves_like 'does not update a Offer and renders to edit'
        it_behaves_like 'shows a error message'
      end
    end
  end

  describe 'DELETE #destory' do
    before { sign_in user_without_beans_and_offers }
    context 'when user have no offers' do
      it 'does not delete a Offer and redirects to beans_path' do
        expect { delete offer_path offer }.not_to change(Offer, :count)
        expect(response).to redirect_to(beans_path)
      end
    end

    context 'when a user has a bean' do
      before { sign_in user_with_a_offer }
      it 'deletes a Offer and redirects to offers_path' do
        expect { delete offer_path offer }.to change(Offer, :count).by(-1)
        expect(response).to redirect_to offers_path
      end
    end
  end

  describe 'GET #search' do
    let(:bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster) }
    let!(:offering_offer) { create(:offer, bean: bean) }
    let!(:preparing_offer) { create(:offer, :on_preparing, bean: bean) }
    let!(:selling_offer) { create(:offer, :on_selling, bean: bean) }
    let!(:sold_offer) { create(:offer, :end_of_sales, bean: bean) }
    # ターゲット
    let!(:roasting_bean) { create(:bean, :with_image_and_tags, name: 'roasting_bean', roaster: user_with_a_offer.roaster) }
    let!(:roasting_offer) { create(:offer, :on_roasting, bean: roasting_bean) }

    before { sign_in user_with_a_offer }
    # ロースト中のウォンツをsearch
    context 'when search for on_offering' do
      let(:status) { 'on_roasting' }
      it 'displays a offer on_roasting not others' do
        get search_offers_path, params: { search: status }
        expect(response).to have_http_status(:success)
        expect(response.body).to include roasting_bean.name
        expect(response.body).to_not include bean.name
      end
    end
  end

  describe 'GET #wanted_users' do
    subject { get wanted_users_offer_path(offer) }
    context 'when a user is not signed in' do
      it 'redirects to new_user_session_path ' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when a user is not belonging to a roaster' do
      before { sign_in user }
      it 'redirects to root_path ' do
        subject
        expect(response).to redirect_to root_path
      end
    end
    context 'when a user does not have the offer' do
      let(:another_user) { create(:user, roaster: another_roaster) }
      let(:another_roaster) { create(:roaster) }
      before { sign_in another_user }
      it 'redirects to beans_path ' do
        subject
        expect(response).to redirect_to beans_path
      end
    end
    context 'when a user is belonging to a roaster with the offer' do
      before { sign_in user_with_a_offer }
      it 'gets offers/index with no offers' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.cookies['roaster_id']).to eq user_with_a_offer.roaster.id.to_s
        expect(response.body).to include("<title>ウォンツしたユーザー#{base_title}</title>")
      end
    end
  end
end
