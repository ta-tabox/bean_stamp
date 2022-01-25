class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  def home
    @pagy, @offers = pagy(current_user.feed)
  end

  def show
    @user = User.find(params[:id])
  end

  def following
    @user = User.find(params[:id])
    @pagy, @roasters = pagy(@user.following_roasters)
  end
end
