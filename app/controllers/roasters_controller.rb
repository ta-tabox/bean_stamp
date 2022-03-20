class RoastersController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_not_belonged_to_roaster_required, only: %i[new create]
  before_action :user_belonged_to_roaster_required, only: %i[home edit update destroy cancel]
  before_action :set_roaster_id_cookie, only: %i[home edit cancel]
  before_action :set_roaster_with_params, only: %i[show edit update destroy followers]
  before_action :set_roaster_with_cookie, only: :home
  before_action :correct_roaster, only: %i[home edit update destroy]
  before_action :ensure_normal_roaster, only: %i[update destroy]

  def home
    offers = @roaster.offers
    offers&.map(&:update_status)
    @pagy, @offers = pagy(offers.includes(:roaster, bean: :bean_images))
  end

  def index
    redirect_to roaster_searches_path
  end

  def show
    offers = @roaster.offers
    offers&.map(&:update_status)
    @pagy, @offers = pagy(offers.includes(:roaster, bean: :bean_images))
  end

  def new
    @roaster = current_user.build_roaster
  end

  def create
    @roaster = current_user.build_roaster(roaster_params)
    if @roaster.save
      flash[:notice] = 'ロースター登録が完了しました'
      current_user.save
      redirect_to @roaster
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @roaster.update(roaster_params)
      flash[:notice] = 'ロースター情報を更新しました'
      redirect_to @roaster
    else
      render 'edit'
    end
  end

  def destroy
    @roaster.destroy
    flash[:notice] = "ロースター「#{@roaster.name}」を削除しました"
    redirect_to home_users_path
  end

  def cancel
    @roaster = current_roaster
  end

  def followers
    @pagy, @users = pagy(@roaster.followers)
  end

  private

  def roaster_params
    params
      .require(:roaster)
      .permit(
        :name,
        :phone_number,
        :prefecture_code,
        :address,
        :describe,
        :image,
        :image_cache,
      )
  end

  def set_roaster_with_params
    @roaster = Roaster.find(params[:id])
  end

  # roasters#home用にcookiesからroaster.idを取得し、setする
  def set_roaster_with_cookie
    @roaster = Roaster.find_by(id: cookies[:roaster_id])
  end

  def correct_roaster
    return if current_user.belonged_roaster?(@roaster)

    redirect_to @roaster,
                alert: '所属していないロースターの更新・削除はできません'
  end

  # ゲストロースターの編集・削除を制限する
  def ensure_normal_roaster
    return unless @roaster.guest?

    redirect_to root_path, alert: 'ゲストロースターの更新・削除はできません'
  end
end
