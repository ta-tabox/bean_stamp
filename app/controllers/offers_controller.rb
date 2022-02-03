class OffersController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required, except: %i[show]
  before_action :roaster_had_bean_requierd, only: %i[create]
  before_action :roaster_had_offer_requierd_and_set_offer, only: %i[edit update destroy]
  before_action :set_search_index, only: %i[index search]

  def index
    @pagy, @offers = pagy(current_roaster.offers.active.recent.includes(:roaster, bean: :bean_images))
  end

  def show
    @offer = Offer.find_by(id: params[:id])
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
    @offer.destroy
    flash[:notice] = "コーヒー豆「#{@offer.bean.name}」のオファーを1件削除しました"
    redirect_to offers_path
  end

  def search # rubocop:disable all
    @pagy, @offers = case params[:search]
                     when 'on_offering'
                       pagy(current_roaster.offers.on_offering.includes(:roaster, bean: :bean_images))
                     when 'on_roasting'
                       pagy(current_roaster.offers.on_roasting.includes(:roaster, bean: :bean_images))
                     when 'on_preparing'
                       pagy(current_roaster.offers.on_preparing.includes(:roaster, bean: :bean_images))
                     when 'on_selling'
                       pagy(current_roaster.offers.on_selling.includes(:roaster, bean: :bean_images))
                     when 'end_of_sales'
                       pagy(current_roaster.offers.end_of_sales.includes(:roaster, bean: :bean_images))
                     else
                       pagy(current_roaster.offers.active.recent.includes(:roaster, bean: :bean_images))
                     end
    render 'index'
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

  def set_search_index
    status_list = Offer.status_list.map { |k, v| [v, k] }
    @search_index = status_list.to_a
  end
end
