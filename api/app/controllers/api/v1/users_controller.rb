class Api::V1::UsersController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_user, only: %i[show roasters_followed_by_user]

  # TODO: レスポンスのデータ構造を変更する { data: xxx }
  def show
    render json: @user
  end

  def roasters_followed_by_user
    roasters = @user.following_roasters
    render json: roasters
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
