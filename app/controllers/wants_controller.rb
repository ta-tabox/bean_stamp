class WantsController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required, only: :index
  before_action :roaster_had_offer_requierd_and_set_offer, only: :index
  before_action :user_had_want_required_and_set_want, only: %i[show receipt]

  def index
    @pagy, @users = pagy(@offer.wanted_users)
  end

  def show; end

  def create
    @offer = Offer.find(params[:offer_id])
    current_user.wanting_offers << @offer
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @offer = Want.find(params[:id]).offer
    current_user.wanting_offers.delete(@offer)
    respond_to do |format|
      format.html { redirect_to request.referer }
      # Ajaxで行うとusers/wantsにてdestroyしたときにwant詳細ページへのリンクが壊れる
      # format.js
    end
  end

  def receipt
    @want.receipted_at = Time.current
    @want.save
    flash[:notice] = '受け取り完了を受け付けました'
    redirect_to @want
  end

  private

  def roaster_had_offer_requierd_and_set_offer
    @offer = current_roaster.offers.find_by(id: params[:offer_id])
    return if @offer

    redirect_to beans_path, alert: 'オファーを登録してください'
  end

  def user_had_want_required_and_set_want
    @want = current_user.wants.find_by(id: params[:id])
    return if @want

    redirect_to wants_users_path, alert: 'ウォンツは登録されていません'
  end
end
