require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /home' do
    before do
      @user = create(:user)
    end
    it 'returns http success' do
      sign_in @user
      get '/users/home'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    before do
      @user = create(:user)
    end
    it 'returns http success' do
      sign_in @user
      get "/users/#{@user.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
