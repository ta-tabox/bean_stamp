class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show following]

  def home
    # enum型のon_offeringでオファー中のオファーを引っ張るとオファーが終了しているのに、
    # statusが更新されていないものを取ることがある→where文でended_atを直接参照するようにした
    offers = Offer.where('ended_at >= ?', Date.current).following_by(current_user)
    offers&.map(&:update_status)
    @pagy, @offers = pagy(offers.includes(:roaster, bean: %i[bean_images roast_level]))
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
