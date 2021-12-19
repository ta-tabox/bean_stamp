require 'rails_helper'

RSpec.describe 'Beans', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/beans/index'
      skip(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/beans/show'
      skip(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/beans/new'
      skip(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/beans/edit'
      skip(response).to have_http_status(:success)
    end
  end
end
