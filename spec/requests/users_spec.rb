require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe 'GET /home' do
    it 'returns http success' do
      get '/users/home'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
