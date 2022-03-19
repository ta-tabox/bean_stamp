require 'rails_helper'

RSpec.describe 'Searches', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/searches/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /roaster' do
    it 'returns http success' do
      get '/searches/roaster'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /offer' do
    it 'returns http success' do
      get '/searches/offer'
      expect(response).to have_http_status(:success)
    end
  end
end
