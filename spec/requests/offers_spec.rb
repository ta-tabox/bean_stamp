require 'rails_helper'

RSpec.describe 'Offers', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/offers/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/offers/show'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/offers/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/offers/edit'
      expect(response).to have_http_status(:success)
    end
  end
end
