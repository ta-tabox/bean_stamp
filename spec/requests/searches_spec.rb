require 'rails_helper'

RSpec.describe 'Searches', type: :request do
  let(:base_title) { ' | BeansApp' }
  let(:user) { create(:user) }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'GET #index' do
    subject { get searches_path }

    context 'when a user is not signed in' do
      it 'redirects to new_user_session_path' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when a user is signed in' do
      before { sign_in user }
      it 'gets searches/index and show offers' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>検索#{base_title}</title>")
        expect(response.body).to include('id="roaster_search"')
        expect(response.body).to include('id="offer_search"')
      end
    end
  end

  describe 'GET #roaster' do
    subject { get roaster_searches_path }
    context 'when a user is not signed in' do
      it 'redirects to new_user_session_path' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when a user is signed in' do
      before { sign_in user }
      it 'gets searches/index and show offers' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>検索#{base_title}</title>")
        expect(response.body).to include roaster.name
      end
    end
  end

  describe 'GET #offer' do
    subject { get offer_searches_path }

    context 'when a user is not signed in' do
      it 'redirects to new_user_session_path' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when a user is signed in' do
      before { sign_in user }
      it 'gets searches/index and show offers' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>検索#{base_title}</title>")
        expect(response.body).to include offer.bean.name
        expect(response.body).to include offer.roaster.name
      end
    end
  end
end
