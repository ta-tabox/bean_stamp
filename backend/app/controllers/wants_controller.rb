class WantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommended_offers, only: %i[index show search]
  before_action :user_had_want_required_and_set_want, only: %i[show receipt rate]
  before_action :set_offer_and_want_required_before_the_receipted_ended_at, only: :create
  before_action :want_required_less_than_the_max_amount, only: :create
  before_action :want_required_not_received, only: :receipt
  before_action :required_want_is_not_rated, only: :rate

  def index
    wants = current_user.wants.includes(:offer)
    wants&.map { |want| want.offer.update_status }
    @pagy, @wants = pagy(wants.includes(offer: [:roaster, { bean: :roast_level }]).recent.active)
  end

  def show
    @want.offer.update_status
  end

  def create
    current_user.want_offers << @offer
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @offer = Want.find(params[:id]).offer
    current_user.want_offers.delete(@offer)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def receipt
    @want.receipted_at = Time.current
    @want.save
    # redirectとAjaxでflashの表示方法を変えている→もっと良い方法はないか？
    respond_to do |format|
      format.html { redirect_to @want, notice: '受け取り完了を受け付けました' }
      format.js { flash.now[:notice] = '受け取り完了を受け付けました' }
    end
  end

  def search
    status = params[:search]
    wants = if status.blank?
              current_user.wants.includes(offer: [:roaster, { bean: :roast_level }]).active.recent
            else
              current_user.wants.includes(offer: [:roaster, { bean: :roast_level }]).search_status(status)
            end
    @pagy, @wants = pagy(wants)
    render 'index'
  end

  def rate
    @want.update(want_params)
    # redirectとAjaxでflashの表示方法を変えている→もっと良い方法はないか？
    respond_to do |format|
      format.html { redirect_to @want, notice: 'コーヒー豆を評価しました' }
      format.js { flash.now[:notice] = 'コーヒー豆を評価しました' }
    end
  end

  private

  def want_params
    params.require(:want).permit(:rate)
  end

  def user_had_want_required_and_set_want
    @want = current_user.wants.find_by(id: params[:id])
    return if @want

    redirect_to wants_path, alert: 'ウォンツは登録されていません'
  end

  def set_offer_and_want_required_before_the_receipted_ended_at
    @offer = Offer.find(params[:offer_id])
    return unless @offer.ended_at.before? Date.current

    redirect_to request.referer, alert: 'オファーは終了しました'
  end

  def want_required_less_than_the_max_amount
    return unless @offer.wants.count >= @offer.amount

    redirect_to request.referer, alert: '数量が上限に達しています'
  end

  def want_required_not_received
    return unless @want.receipted_at?

    redirect_to @want, alert: 'すでに受け取りが完了しています'
  end

  def required_want_is_not_rated
    return if @want.unrated?

    redirect_to @want, alert: 'すでに評価が完了しています'
  end
end
