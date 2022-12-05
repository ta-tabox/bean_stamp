class Api::V1::RoastersController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_not_belonged_to_roaster_required, only: %i[create]
  before_action :user_belonged_to_roaster_required, only: %i[update destroy]
  before_action :set_roaster, only: %i[show update destroy followers]
  before_action :correct_roaster, only: %i[update destroy]

  def show
    render json: { status: 'success', data: @roaster }
  end

  def create
    roaster = current_api_v1_user.build_roaster(roaster_params)
    if roaster.save
      current_api_v1_user.save
      render json: { status: 'success', data: roaster }
    else
      render json: { status: 'error', messages: roaster.errors.full_messages }
    end
  end

  def update
    if @roaster.update(roaster_params)
      render json: { status: 'success', data: @roaster }
    else
      render json: { status: 'error', messages: @roaster.errors.full_messages }
    end
  end

  def destroy
    if @roaster.destroy
      render json: { status: 'success', message: 'ロースターを削除しました' }
    else
      render json: { status: 'error', message: 'ロースターの削除に失敗しました' }
    end
  end

  def followers
    users = @roaster.followers
    render json: { status: 'success', data: users }
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
    return if current_api_v1_user.belonged_roaster?(@roaster)

    render json: { status: 'error', message: '所属していないロースターの更新・削除はできません' }
  end
end
