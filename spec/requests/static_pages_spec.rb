require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:user) { create(:user) }
  let(:base_title) { 'BeansApp' }

  describe 'GET #home' do
    context 'when with sign out' do
      it 'gets home' do
        get home_url
        expect(response).to have_http_status(:success)
        expect(response.body).to match(%r{<title>TOP | #{base_title}</title>}i)
      end
    end

    context 'when with sign in' do
      it 'redirects to user_home' do
        sign_in user
        get home_url
        expect(response).to redirect_to(user_home_path)
      end
    end
  end

  describe 'GET #help' do
    it 'gets help' do
      get help_url
      expect(response).to have_http_status(:success)
      expect(response.body).to match(%r{<title>HELP | #{base_title}</title>}i)
    end
  end

  describe 'GET #about' do
    it 'gets about' do
      get about_url
      expect(response).to have_http_status(:success)
      expect(response.body).to match(%r{<title>ABOUT | #{base_title}</title>}i)
    end
  end
end
