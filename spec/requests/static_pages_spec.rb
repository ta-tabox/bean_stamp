require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'BeansApp' }
  let(:user) { create(:user) }

  describe 'GET #home' do
    context 'when user is signed out' do
      it 'gets home' do
        get home_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>Top | #{base_title}</title>")
      end
    end

    context 'when user is signed in' do
      it 'redirects to user_home' do
        sign_in user
        get home_path
        expect(response).to redirect_to(user_home_path)
      end
    end
  end

  describe 'GET #help' do
    it 'gets help' do
      get help_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>Help | #{base_title}</title>")
    end
  end

  describe 'GET #about' do
    it 'gets about' do
      get about_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>About | #{base_title}</title>")
    end
  end
end
