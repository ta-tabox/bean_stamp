require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:base_title) { ' | BeansApp' }
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
    subject { get search_likes_path, params: { search: status } }

    # beanの名前を変えることでincludesで正しいlikeが抽出できているかテストする
    let!(:offering_bean) { create(:bean, :with_image_and_tags, roaster: roaster, name: 'offering_bean') }
    let!(:roasting_bean) { create(:bean, :with_image_and_tags, roaster: roaster, name: 'roasting_bean') }
    let!(:preparing_bean) { create(:bean, :with_image_and_tags, roaster: roaster, name: 'preparing_bean') }
    let!(:start_selling_bean) { create(:bean, :with_image_and_tags, roaster: roaster, name: 'start_selling_bean') }
    let!(:selling_bean) { create(:bean, :with_image_and_tags, roaster: roaster, name: 'selling_bean') }
    let!(:sold_bean) { create(:bean, :with_image_and_tags, roaster: roaster, name: 'sold_bean') }
    # 本日でオファー終わり
    let!(:offering_offer) { create(:offer, ended_at: Date.current, bean: offering_bean) }
    # 本日までロースト中
    let!(:roasting_offer) { create(:offer, :on_roasting, roasted_at: Date.current, bean: roasting_bean) }
    # 本日まで準備中、明日から受付開始
    let!(:preparing_offer) { create(:offer, :on_preparing, receipt_started_at: Date.current.next_day(1), bean: preparing_bean) }
    # 本日から受付開始
    let!(:start_selling_offer) { create(:offer, :on_selling, receipt_started_at: Date.current, bean: start_selling_bean) }
    # 本日まで受付中
    let!(:selling_offer) { create(:offer, :on_selling, receipt_ended_at: Date.current, bean: selling_bean) }
    # 昨日まで受付中、本日は受付終了
    let!(:sold_offer) { create(:offer, :end_of_sales, receipt_ended_at: Date.current.prev_day(1), bean: sold_bean) }

    before do
      sign_in user
      offers = [offering_offer, roasting_offer, preparing_offer, start_selling_offer, selling_offer, sold_offer]
      offers.each { |offer| user.like_offers << offer }
    end

    # 境界値のテストを含む
    context 'when search for on_offering' do
      let(:status) { 'on_offering' }
      it 'displays a offer on_offering not others' do
        subject
        expect(response).to have_http_status(:success)
        # 本日までオファー中の豆を表示する
        expect(response.body).to include offering_bean.name
        expect(response.body).to_not include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        expect(response.body).to_not include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for on_roasting' do
      let(:status) { 'on_roasting' }
      it 'displays a offer on_roasting not others' do
        subject
        expect(response).to have_http_status(:success)
        # 本日がended_atのオファーを表示しない
        expect(response.body).to_not include offering_bean.name
        # 本日がroasted_atのオファーを表示する
        expect(response.body).to include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        expect(response.body).to_not include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for on_preparing' do
      let(:status) { 'on_preparing' }
      it 'displays a offer on_preparing not others' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to_not include offering_bean.name
        # 本日がroasted_atのオファーを表示しない
        expect(response.body).to_not include roasting_bean.name
        # 明日がreceipt_started_atのオファーを表示する
        expect(response.body).to include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        expect(response.body).to_not include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for on_selling' do
      let(:status) { 'on_selling' }
      it 'displays a offer on_selling not others' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to_not include offering_bean.name
        expect(response.body).to_not include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        # 本日がreceipt_started_atのオファーを表示する
        expect(response.body).to include start_selling_bean.name
        # 本日がreceipt_ended_atのオファーを表示する
        expect(response.body).to include selling_bean.name
        expect(response.body).to_not include sold_bean.name
      end
    end

    context 'when search for end_of_sales' do
      let(:status) { 'end_of_sales' }
      it 'displays a offer end_of_sales not others' do
        subject
        expect(response).to have_http_status(:success)
        expect(response.body).to_not include offering_bean.name
        expect(response.body).to_not include roasting_bean.name
        expect(response.body).to_not include preparing_bean.name
        expect(response.body).to_not include start_selling_bean.name
        # 本日がreceipt_ended_atのオファーを表示しない
        expect(response.body).to_not include selling_bean.name
        # 昨日がreceipt_ended_atのオファーを表示する
        expect(response.body).to include sold_bean.name
      end
    end
  end
end
