require 'rails_helper'

RSpec.describe 'Roasters', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/roasters/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/roasters/show'
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
      get '/roasters/edit'
      expect(response).to have_http_status(:success)
    end
  end
end
