class OffersController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required
  before_action :set_offer, only: %i[show edit update destroy]

  def index
    @pagy, @offers = pagy(current_roaster.offers)
  end

  def show; end

  def new
    set_bean
    @offer = @bean.offers.build
  end

  def create
    @offer = Offer.create(offer_params)
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
    @offer.destroy
    flash[:notice] = "コーヒー豆「#{@offer.bean.name}」のオファーを1件削除しました"
    redirect_to offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:bean_id, :ended_at, :roasted_at, :receipt_started_at, :receipt_ended_at, :price, :weight, :amount)
  end

  def set_bean
    @bean = current_roaster.beans.find_by(id: params[:bean_id])
    return if @bean

    redirect_to beans_path, alert: 'コーヒー豆を登録してください'
  end

  def set_offer
    @offer = current_roaster.offers.find_by(id: params[:id])
    return if @offer

    redirect_to beans_path, alert: 'オファーを登録してください'
  end
end
