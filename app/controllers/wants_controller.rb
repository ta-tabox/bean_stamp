class WantsController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required, except: :index
  before_action :roaster_had_offer_requierd_and_set_offer, only: :index

  def index
    @pagy, @users = pagy(@offer.wanted_users)
  end

  private

  def roaster_had_offer_requierd_and_set_offer
    @offer = current_roaster.offers.find_by(id: params[:offer_id])
    return if @offer

    redirect_to beans_path, alert: 'オファーを登録してください'
  end
end
