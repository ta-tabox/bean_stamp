require 'rails_helper'

RSpec.describe 'Offers', type: :request do
  let(:base_title) { ' | BeansApp' }
  # コーヒー豆、オファーを持たないロースターに所属したユーザー
  let(:user_without_beans_and_offers) { create(:user, :with_roaster) }

  # コーヒー豆を持ったロースターに所属したユーザー
  # let(:user_with_a_bean) { create(:user, :with_roaster) }
  # let(:bean_with_no_offers) { create(:bean, :with_image, :with_3_taste_tags, roaster: user_with_a_bean.roaster) }

  # オファー付きのコーヒー豆を持ったロースターに所属したユーザー
  let(:user_with_a_offer) { create(:user, :with_roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: user_with_a_offer.roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'GET #index' do
    subject { get offers_path }
    context 'when a user have no offers' do
      before { sign_in user_without_beans_and_offers }
      it 'gets offers/index with no offers' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>オファー一覧#{base_title}</title>")
        expect(response.body).not_to include(offer.bean.name)
      end
    end
    context 'when a user have a offer' do
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
    context 'when a user have no offers' do
      before { sign_in user_without_beans_and_offers }
      it 'redirects to beans_path' do
        subject
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'オファーを登録してください'
      end
    end
    context 'when a user have a offer' do
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
    context 'when user have no beans' do
      before { sign_in user_without_beans_and_offers }
      it 'redirects to beans_path' do
        subject
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'コーヒー豆を登録してください'
      end
    end
    context 'when a user have a bean' do
      before { sign_in user_with_a_offer }
      it 'gets offers/new' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>オファー作成#{base_title}</title>")
      end
    end
  end

  describe 'GET #edit' do
    subject { get edit_offer_path offer }
    context 'when a user have no offers' do
      before { sign_in user_without_beans_and_offers }
      it 'gets offers/edit' do
        subject
        expect(response).to redirect_to beans_path
        follow_redirect!
        expect(response.body).to include 'オファーを登録してください'
      end
    end
    context 'when a user have a offer' do
      before { sign_in user_with_a_offer }
      it 'gets offers/edit' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>オファー編集#{base_title}</title>")
      end
    end
  end
end
