class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show following]

  def home
    offers = Offer.following_by(current_user).on_offering
    @pagy, @offers = pagy(offers)
  end

  def show; end

  def following
    @pagy, @roasters = pagy(@user.following_roasters)
  end

  def wants
    @pagy, @wants = pagy(current_user.wants.includes(:roaster, :offer, bean: :bean_images))
    @wants&.map { |want| want.offer.set_status }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
