class Api::V1::OffersController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_belonged_to_roaster_required, except: %i[show]
  before_action :roaster_had_bean_requierd, only: %i[create]
  before_action :roaster_had_offer_requierd_and_set_offer, only: %i[update destroy wanted_users]
  # TODO: before_action :set_recommended_offers ユーザーのおすすめのオファーをセットする

  def index
    offers = current_api_v1_roaster.offers
    offers&.map(&:update_status)
    pagy, @offers = pagy(offers.includes(:roaster, { bean: %i[roast_level bean_images] }).active.recent)
    pagy_headers_merge(pagy)
    render formats: :json
  end

  def show
    @offer = Offer.find_by(id: params[:id])
    @offer.update_status
    render formats: :json
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      render 'show', formats: :json
    else
      render json: { messages: @offer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @offer.update(offer_params)
      render 'show', formats: :json
    else
      render json: { messages: @offer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @offer.wants.any?
      render json: { messages: ['オファーはウォンツされています'] }, status: :unprocessable_entity
      return
    end

    if @offer.destroy
      render json: { messages: ['オファーを1件削除しました'] }, status: :ok
    else
      render json: { messages: ['オファーの削除に失敗しました'] }, status: :method_not_allowed
    end
  end

  def search
    status = params[:search]
    offers = if status.blank?
               current_api_v1_roaster.offers.active.recent
             else
               current_api_v1_roaster.offers.search_status(status)
             end
    pagy, @offers = pagy(offers.includes(:roaster, { bean: %i[roast_level bean_images] }))
    pagy_headers_merge(pagy)
    render 'index', formats: :json
  end

  def wanted_users
    pagy, @users = pagy(@offer.wanted_users)
    pagy_headers_merge(pagy)
    render formats: :json
  end

  private

  def offer_params
    params.require(:offer).permit(:bean_id, :ended_at, :roasted_at, :receipt_started_at, :receipt_ended_at, :price, :weight, :amount)
  end

  def roaster_had_bean_requierd
    return if current_api_v1_roaster.beans.find_by(id: offer_params[:bean_id])

    render json: { messages: ['コーヒー豆を登録してください'] }, status: :not_found
  end

  def set_offer
    @offer = Offer.find_by(id: params[:id])
  end

  def roaster_had_offer_requierd_and_set_offer
    @offer = current_api_v1_roaster.offers.find_by(id: params[:id])
    return if @offer

    render json: { messages: ['オファーを登録してください'] }, status: :not_found
  end
end
