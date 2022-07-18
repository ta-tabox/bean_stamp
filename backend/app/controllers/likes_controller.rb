class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommended_offers, only: %i[index search]

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

  def search
    status = params[:search]
    likes = if status.blank?
              current_user.likes.includes(offer: [:roaster, { bean: :roast_level }]).recent
            else
              current_user.likes.includes(offer: [:roaster, { bean: :roast_level }]).search_status(status)
            end
    @pagy, @likes = pagy(likes)
    render 'index'
  end
end
