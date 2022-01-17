class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  def home
    # フォローリソースを実装するときにユーザーがフォローするロースターのオファーのみに修正する
    @pagy, @offers = pagy(Offer.all)
  end

  def show
    @user = User.find(params[:id])
  end
end
