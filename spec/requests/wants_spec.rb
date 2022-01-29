require 'rails_helper'

RSpec.describe 'Wants', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/wants/index'
      expect(response).to have_http_status(:success)
    end
  end
end
