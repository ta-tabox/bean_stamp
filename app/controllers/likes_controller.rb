class LikesController < ApplicationController
  before_action :user_signed_in_required

  def index
    likes = current_user.likes.includes(:offer)
    likes&.map { |want| want.offer.update_status }
    @pagy, @likes = pagy(likes.includes(offer: [:roaster, { bean: :roast_level }]).recent)
  end

  def create
    @offer = Offer.find(params[:offer_id])
    current_user.like_offers << @offer
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @offer = Like.find(params[:id]).offer
    current_user.like_offers.delete(@offer)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end
end
