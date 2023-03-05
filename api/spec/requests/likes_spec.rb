require 'rails_helper'

RSpec.describe 'Likes', type: :request, skip: true do
  let(:base_title) { ' | BeanStamp' }
  let(:user) { create(:user) }
  let(:another_user) { create(:user, name: '他のユーザー') }
  let!(:roaster) { create(:roaster) }
  let!(:bean) { create(:bean, :with_image, :with_3_taste_tags, roaster: roaster) }
  let!(:offer) { create(:offer, bean: bean) }

  describe 'GET #index' do
    subject { get likes_path }

    context 'when a user is not signed in' do
      it 'redirects to new_user_session_path' do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when a user is signed in and has a like' do
      let!(:like) { create(:like, user_id: user.id, offer_id: offer.id) }
      before { sign_in user }
      it "gets likes/index and shows a like's info" do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<title>お気に入り#{base_title}</title>")
        expect(response.body).to include like.bean.name
        expect(response.body).to include like.roaster.name
      end
    end
  end

  describe 'POST #create' do
    subject { proc { post offer_likes_path(offer), headers: { 'HTTP_REFERER' => likes_url } } }
    context 'when user is not signed in' do
      it 'redirects to new_user_session_path ' do
        subject.call
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is signed in' do
      before { sign_in user }
      it { is_expected.to change(Like, :count).by(1) }
      it {
        is_expected.to change(user.likes, :count).by(1)
      }
      it { is_expected.to change(offer.likes, :count).by(1) }
      context 'with Ajax' do
        subject { proc { post offer_likes_path(offer), xhr: true } }
        it { is_expected.to change(Like, :count).by(1) }
      end
    end
  end

  describe 'DELET #destroy' do
    let(:like) { user.likes.find_by(offer_id: offer.id) }
    subject { proc { delete like_path(like), headers: { 'HTTP_REFERER' => likes_url } } }
    before do
      user.like_offers << offer
    end
    context 'when user is not signed in' do
      it 'redirects to new_user_session_path ' do
        subject.call
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when user is signed in' do
      before { sign_in user }
      it { is_expected.to change(Like, :count).by(-1) }
      it { is_expected.to change(user.likes, :count).by(-1) }
      it { is_expected.to change(offer.likes, :count).by(-1) }
      context 'with Ajax' do
        subject { proc { delete like_path(like), xhr: true } }
        it { is_expected.to change(Like, :count).by(-1) }
      end
    end
  end

  describe 'GET #search' do
    let(:bean) { create(:bean, :with_image_and_tags) }
    let(:offering_offer) { create(:offer, bean: bean) }
    let(:preparing_offer) { create(:offer, :on_preparing, bean: bean) }
    let(:selling_offer) { create(:offer, :on_selling, bean: bean) }
    let(:sold_offer) { create(:offer, :end_of_sales, bean: bean) }
    # ターゲット
    let(:roasting_bean) { create(:bean, :with_image_and_tags, name: 'roasting_bean') }
    let(:roasting_offer) { create(:offer, :on_roasting, bean: roasting_bean) }

    before do
      sign_in user
      user.like_offers.push(offering_offer, roasting_offer, preparing_offer, selling_offer, sold_offer)
    end

    # ロースト中のお気に入りを検索する
    context 'when search for on_offering' do
      let(:status) { 'on_roasting' }
      it 'displays a offer on_roasting not others' do
        get search_likes_path, params: { search: status }
        expect(response).to have_http_status(:success)
        expect(response.body).to include roasting_bean.name
        expect(response.body).to_not include bean.name
      end
    end
  end
end
