class RoastersController < ApplicationController
  def index; end

  def show; end

  def new
    @roaster = current_user.build_roaster
  end

  def edit; end

  def create
    @roaster = current_user.build_roaster(roaster_params)
    if @roaster.save
      flash[:success] = 'ロースター登録が完了しました'
      current_user.save
      redirect_to @roaster
    else
      render 'new'
    end
  end

  def update; end

  def destroy; end

  private

  def roaster_params
    params.require(:roaster).permit(:name, :phone_number, :address, :describe)
  end
end
