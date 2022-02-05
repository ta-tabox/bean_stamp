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
        expect(response.body).to include("<title>オファー一覧#{base_title}</title>")
        expect(response.body).not_to include(offer.bean.name)
      end
    end
    context 'when a user has a offer' do
      before { sign_in user_with_a_offer }
      it 'gets offers/index with a offer' do
        subject
        expect(response).to have_http_status(:success)
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
        expect(response.body).to include("<title>オファー詳細#{base_title}</title>")
      end
    end
    context 'when a user belongs to a roaster who had no offers' do
      before { sign_in user_without_beans_and_offers }
      it "gets offers/show and shows the bean's name of the offer" do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>オファー詳細#{base_title}</title>")
      end
    end
    context 'when a user belongs to a roaster who had a offer' do
      before { sign_in user_with_a_offer }
      it "gets offers/show and shows the bean's name of the offer" do
        subject
        expect(response).to have_http_status(:success)
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
        let(:error_message) { '販売価格は数値で入力してください' }

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
      context 'when the ended_at is earlier than today' do
        let(:offer_params) { attributes_for(:offer, :too_early_ended_at, bean_id: bean.id) }
        let(:error_message) { 'オファー終了日は本日以降の日付を入力してください' }

        it_behaves_like 'does not create a Offer and renders to new'
        it_behaves_like 'shows a error message'
      end

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
    subject { get search_offers_path, params: { search: status } }

    # beanの名前を変えることでincludesで正しいofferが抽出できているかテストする
    let!(:offering_bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster, name: 'offering_bean') }
    let!(:roasting_bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster, name: 'roasting_bean') }
    let!(:preparing_bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster, name: 'preparing_bean') }
    let!(:start_selling_bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster, name: 'start_selling_bean') }
    let!(:selling_bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster, name: 'selling_bean') }
    let!(:sold_bean) { create(:bean, :with_image_and_tags, roaster: user_with_a_offer.roaster, name: 'sold_bean') }
    # 本日でオファー終わり
    let!(:offering_offer) { create(:offer, ended_at: Date.current, bean: offering_bean) }
    # 本日までロースト中
    let!(:roasting_offer) { create(:offer, :on_roasting, roasted_at: Date.current, bean: roasting_bean) }
    # 本日まで準備中、明日から受付開始
    let!(:preparing_offer) { create(:offer, :on_preparing, receipt_started_at: Date.current.next_day(1), bean: preparing_bean) }
    # 本日から受付開始
    let!(:start_sellng_offer) { create(:offer, :on_selling, receipt_started_at: Date.current, bean: start_selling_bean) }
    # 本日まで受付中
    let!(:selling_offer) { create(:offer, :on_selling, receipt_ended_at: Date.current, bean: selling_bean) }
    # 昨日まで受付中、本日は受付終了
    let!(:sold_offer) { create(:offer, :end_of_sales, receipt_ended_at: Date.current.prev_day(1), bean: sold_bean) }

    before { sign_in user_with_a_offer }

    # 境界値のテストを含む
    context 'when search for on_offering' do
      let(:status) { 'on_offering' }
      it 'displays a offer on_offering not others' do
        subject
        expect(response).to have_http_status(:success)
        # 本日までオファー中の豆を表示する
        expect(response.body).to include offering_bean.name
        expect(response.body).to_not include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        expect(response.body).to_not include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for on_roasting' do
      let(:status) { 'on_roasting' }
      it 'displays a offer on_roasting not others' do
        subject
        expect(response).to have_http_status(:success)
        # 本日がended_atのオファーを表示しない
        expect(response.body).to_not include offering_bean.name
        # 本日がroasted_atのオファーを表示する
        expect(response.body).to include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        expect(response.body).to_not include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for on_preparing' do
      let(:status) { 'on_preparing' }
      it 'displays a offer on_preparing not others' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to_not include offering_bean.name
        # 本日がroasted_atのオファーを表示しない
        expect(response.body).to_not include roasting_bean.name
        # 明日がreceipt_started_atのオファーを表示する
        expect(response.body).to include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        expect(response.body).to_not include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for on_selling' do
      let(:status) { 'on_selling' }
      it 'displays a offer on_selling not others' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to_not include offering_bean.name
        expect(response.body).to_not include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        # 本日がreceipt_started_atのオファーを表示する
        expect(response.body).to include start_selling_bean.name
        # 本日がreceipt_ended_atのオファーを表示する
        expect(response.body).to include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for end_of_sales' do
      let(:status) { 'end_of_sales' }
      it 'displays a offer end_of_sales not others' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to_not include offering_bean.name
        expect(response.body).to_not include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        # 本日がreceipt_ended_atのオファーを表示しない
        expect(response.body).to_not include selling_bean.name
        # 昨日がreceipt_ended_atのオファーを表示する
        expect(response.body).to include sold_bean.name
      end
    end
  end
end
