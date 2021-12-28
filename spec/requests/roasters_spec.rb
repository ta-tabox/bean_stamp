require 'rails_helper'

RSpec.describe 'Roasters', type: :request do
  let(:roaster) { create(:roaster) }
  let(:user) { create(:user, roaster: roaster) }
  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get '/roasters'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get "/roasters/#{roaster.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/roasters/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get "/roasters/#{roaster.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
