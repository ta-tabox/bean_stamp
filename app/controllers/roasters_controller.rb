class RoastersController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_not_belonged_to_roaster_required, only: %i[new create]
  before_action :user_belonged_to_roaster_required, only: %i[edit update destroy cancel]
  before_action :set_roaster, only: %i[show edit update destroy followers]
  before_action :correct_roaster, only: %i[edit update destroy]
  before_action :ensure_normal_roaster, only: %i[update destroy]

  def index; end

  def show
    offers = @roaster.offers.with_associations
    offers&.map(&:set_status)
    @pagy, @offers = pagy(offers)
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

  def set_roaster
    @roaster = Roaster.find(params[:id])
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
