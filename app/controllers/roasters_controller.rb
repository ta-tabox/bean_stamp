class RoastersController < ApplicationController
  before_action :correct_roaster, only: %i[edit update destroy]

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

  def destroy; end

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
end
