class Api::V1::RoasterRelationshipsController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_user
  before_action :set_roaster_from_all, only: :create
  before_action :set_roaster_from_following_roasters, only: :destroy

  def create
    @user.following_roasters << @roaster
    render formats: :json
  end

  def destroy
    @user.following_roasters.delete(@roaster)
    render formats: :json
  end

  private

  def set_user
    @user = current_api_v1_user
  end

  def set_roaster_from_all
    @roaster = Roaster.find_by(id: params[:roaster_id])
    return if @roaster

    render json: { message: 'ロースターが存在しません' }, status: :not_found
  end

  def set_roaster_from_following_roasters
    @roaster = RoasterRelationship.find_by(id: params[:id])&.roaster
    return if @roaster

    render json: { message: 'フォローが存在しません' }, status: :not_found
  end
end
