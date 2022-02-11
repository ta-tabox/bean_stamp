class WantsController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_had_want_required_and_set_want, only: %i[show receipt]
  before_action :set_offer_and_want_required_before_the_receipted_ended_at, only: :create
  before_action :want_required_less_than_the_max_amount, only: :create
  before_action :want_required_not_received, only: :receipt

  def index
    @pagy, @wants = pagy(current_user.wants.active.recent.includes(:roaster, bean: :bean_images))
    set_offer_status
  end

  def show
    @want.offer.set_status
  end

  def create
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
      # JSで非表示にするようにできたらAjaxで処理する
      # format.js
    end
  end

  def receipt
    @want.receipted_at = Time.current
    @want.save
    flash[:notice] = '受け取り完了を受け付けました'
    redirect_to @want
  end

  def search
    status = params[:search]
    wants = if status.blank?
              current_user.wants.active.recent
            else
              current_user.wants.search_status(status)
            end
    @pagy, @wants = pagy(wants)
    set_offer_status
    render 'index'
  end

  private

  def set_offer_status
    @wants&.map { |want| want.offer.set_status }
    @want&.offer&.set_status
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
end
