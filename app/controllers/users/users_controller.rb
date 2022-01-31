class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show following]

  def home
    @pagy, @offers = pagy(Offer.following_by(current_user))
  end

  def show; end

  def following
    @pagy, @roasters = pagy(@user.following_roasters)
  end

  def wants
    @pagy, @wants = pagy(current_user.wants.includes(:roaster, :offer, bean: :bean_images))
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
