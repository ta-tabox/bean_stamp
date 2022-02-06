class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show following]

  def home
    offers = Offer.following_by(current_user).on_offering
    @pagy, @offers = pagy(offers)
    @offers&.map(&:set_status)
  end

  def show; end

  def following
    @pagy, @roasters = pagy(@user.following_roasters)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
