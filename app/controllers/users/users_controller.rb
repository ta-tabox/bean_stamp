class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  def home
    # フォローリソースを実装するときにユーザーがフォローするロースターのオファーのみに修正する
    @pagy, @offers = pagy(Offer.joins(:bean).where('roaster_id IN (?)', current_user.following_roaster_ids).includes(:roaster, bean: :bean_images))
  end

  def show
    @user = User.find(params[:id])
  end

  def following
    @user = User.find(params[:id])
    @pagy, @roasters = pagy(@user.following_roasters)
  end
end
