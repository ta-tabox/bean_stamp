class OffersController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required
  # オファーの期日関連のバリデーションを追加する
  # オファー開始日は当日以降でないといけない且つ＜1ヶ月後
  # 焙煎日はオファー開始日＜焙煎日＜＝受け取り開始日且つ＜1ヶ月後
  # 受け取り開始日は焙煎日＜受け取り開始日＜受け取り終了日且つ＜1ヶ月後
  # 受け取り終了日は受け取り開始日＜受け取り終了日＜2ヶ月後

  def index
    @pagy, @offers = pagy(current_roaster.offers)
  end

  def show; end

  def new
    set_bean
    @offer = @bean.offers.build
    @bean_images = @bean.bean_images.all
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

  def edit; end

  def update; end

  def destroy; end

  private

  def offer_params
    params.require(:offer).permit(:bean_id, :ended_at, :roasted_at, :receipt_started_at, :receipt_ended_at, :price, :weight, :amount)
  end

  def set_bean
    @bean = current_roaster.beans.find_by(id: params[:bean_id])
    return if @bean

    redirect_to beans_path, alert: 'コーヒー豆を登録してください'
  end
end
