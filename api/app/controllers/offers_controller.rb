class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_belonged_to_roaster_required, except: %i[show]
  before_action :set_recommended_offers
  before_action :set_roaster_id_cookie, only: %i[index new edit search wanted_users]
  before_action :roaster_had_bean_requierd, only: %i[create]
  before_action :roaster_had_offer_requierd_and_set_offer, only: %i[edit update destroy wanted_users]

  def index
    offers = current_roaster.offers
    offers&.map(&:update_status)
    @pagy, @offers = pagy(offers.includes(:roaster, { bean: %i[roast_level bean_images] }).active.recent)
  end

  def show
    @offer = Offer.find_by(id: params[:id])
    @offer.update_status
  end

  def new
    @bean = current_roaster.beans.find_by(id: params[:bean_id])
    if @bean
      @offer = @bean.offers.build
    else
      redirect_to beans_path, alert: 'コーヒー豆を登録してください'
    end
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = 'オファーを作成しました'
      redirect_to @offer
    else
      @bean = current_roaster.beans.find_by(id: offer_params[:bean_id])
      render 'new'
    end
  end

  def edit
    @bean = @offer.bean
  end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'オファーを更新しました'
      redirect_to @offer
    else
      @bean = @offer.bean
      render 'edit'
    end
  end

  def destroy
    if @offer.wants.any?
      redirect_to request.referer, alert: "コーヒー豆「#{@offer.bean.name}」のオファーはウォンツされています"
    else
      @offer.destroy
      flash[:notice] = "コーヒー豆「#{@offer.bean.name}」のオファーを1件削除しました"
      redirect_to offers_path
    end
  end

  def search
    status = params[:search]
    offers = if status.blank?
               current_roaster.offers.active.recent
             else
               current_roaster.offers.search_status(status)
             end
    @pagy, @offers = pagy(offers.includes(:roaster, { bean: %i[roast_level bean_images] }))
    render 'index'
  end

  def wanted_users
    @pagy, @users = pagy(@offer.wanted_users)
  end

  private

  def offer_params
    params.require(:offer).permit(:bean_id, :ended_at, :roasted_at, :receipt_started_at, :receipt_ended_at, :price, :weight, :amount)
  end

  def roaster_had_bean_requierd
    return if current_roaster.beans.find_by(id: offer_params[:bean_id])

    redirect_to beans_path, alert: 'コーヒー豆を登録してください'
  end

  def set_offer
    @offer = Offer.find_by(id: params[:id])
  end

  def roaster_had_offer_requierd_and_set_offer
    @offer = current_roaster.offers.find_by(id: params[:id])
    return if @offer

    redirect_to beans_path, alert: 'オファーを登録してください'
  end
end
