class WantsController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required, only: :index
  before_action :roaster_had_offer_requierd_and_set_offer, only: :index

  def index
    @pagy, @users = pagy(@offer.wanted_users)
  end

  def show
    @want = current_user.wants.find(params[:id])
    @offer = @want.offer
  end

  def create
    @offer = Offer.find(params[:offer_id])
    current_user.wanting_offers << @offer
    respond_to do |format|
      format.html { redirect_to @offer }
      format.js
    end
  end

  def destroy
    @offer = Want.find(params[:id]).offer
    current_user.wanting_offers.delete(@offer)
    respond_to do |format|
      format.html { redirect_to @offer }
      format.js
    end
  end

  private

  def roaster_had_offer_requierd_and_set_offer
    @offer = current_roaster.offers.find_by(id: params[:offer_id])
    return if @offer

    redirect_to beans_path, alert: 'オファーを登録してください'
  end
end
