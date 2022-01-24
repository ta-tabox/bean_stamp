class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  def home
    # フォローリソースを実装するときにユーザーがフォローするロースターのオファーのみに修正する
    @pagy, @offers = pagy(Offer.all.includes(:roaster, bean: :bean_images))
  end

  def show
    @user = User.find(params[:id])
  end

  def following
    @user = User.find(params[:id])
    @pagy, @roasters = pagy(@user.following_roasters)
  end
end
