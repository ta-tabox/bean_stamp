class Api::V1::RoastersController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_not_belonged_to_roaster_required, only: %i[create]
  before_action :user_belonged_to_roaster_required, only: %i[update destroy]
  before_action :set_roaster, only: %i[show update destroy followers offers]
  before_action :correct_roaster, only: %i[update destroy]

  def show
    render formats: :json
  end

  def create
    @roaster = current_api_v1_user.build_roaster(roaster_params)
    if @roaster.save
      current_api_v1_user.save
      render formats: :json
    else
      render json: { messages: @roaster.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @roaster.update(roaster_params)
      render formats: :json
    else
      render json: { messages: @roaster.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @roaster.destroy
      render json: { messages: ['ロースターを削除しました'] }, status: :ok
    else
      render json: { messages: ['ロースターの削除に失敗しました'] }, status: :method_not_allowed
    end
  end

  def followers
    pagy, @users = pagy(@roaster.followers)
    pagy_headers_merge(pagy)
    render formats: :json
  end

  def offers
    offers = @roaster.offers.recent
    offers&.map(&:update_status)
    pagy, @offers = pagy(offers.includes(:roaster, bean: :bean_images))
    pagy_headers_merge(pagy)
    render formats: :json
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

    render json: { messages: ['所属していないロースターの更新・削除はできません'] }, status: :method_not_allowed
  end
end
