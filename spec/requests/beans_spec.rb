require 'rails_helper'

RSpec.describe 'Beans', type: :request do
  let(:roaster) { create(:roaster) }
  let(:user) { create(:user, roaster: roaster) }
  let(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/beans'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get "/beans/#{bean.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/beans/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get "/beans/#{bean.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
