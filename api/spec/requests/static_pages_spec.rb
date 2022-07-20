require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { ' | BeanStamp' }
  let(:user) { create(:user) }

  describe 'GET #home' do
    subject { get home_path }

    context 'when a user is signed out' do
      it 'gets home' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>Home#{base_title}</title>")
      end
    end

    context 'when a user is signed in' do
      before { sign_in user }
      it { is_expected.to redirect_to home_users_path }
    end
  end

  describe 'GET #help' do
    it 'gets help' do
      get help_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>Help#{base_title}</title>")
    end
  end

  describe 'GET #about' do
    it 'gets about' do
      get about_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>About#{base_title}</title>")
    end
  end
end
