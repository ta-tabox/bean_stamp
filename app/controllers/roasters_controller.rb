class RoastersController < ApplicationController
  before_action :user_signed_in_required
  before_action :correct_roaster, only: %i[edit update destroy]
  before_action :ensure_normal_roaster, only: %i[update destroy]

  def index; end

  def show
    @roaster = Roaster.find(params[:id])
  end

  def new
    @roaster = current_user.build_roaster
  end

  def edit
    @roaster = Roaster.find(params[:id])
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

  def update
    @roaster = Roaster.find(params[:id])
    if @roaster.update(roaster_params)
      flash[:notice] = 'ロースター情報を更新しました'
      redirect_to @roaster
    else
      render 'edit'
    end
  end

  def destroy
    roaster = Roaster.find(params[:id])
    roaster.destroy
    flash[:notice] = "ロースター「#{roaster.name}」を削除しました"
    redirect_to user_home_path
  end

  def cancel
    @roaster = current_user.roaster
  end

  private

  def roaster_params
    params
      .require(:roaster)
      .permit(:name, :phone_number, :address, :describe, :image, :image_cache)
  end

  def correct_roaster
    @roaster = Roaster.find(params[:id])
    redirect_to @roaster unless current_user.roaster?(@roaster)
  end

  # ゲストロースターかチェックする
  def ensure_normal_roaster
    roaster = Roaster.find(params[:id])
    redirect_to root_path, alert: 'ゲストロースターの更新・削除はできません' if roaster.name == 'ゲストロースター'
  end
end
