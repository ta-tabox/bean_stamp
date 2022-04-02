class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show following]
  before_action :reset_roaster_id_cookie, only: :home
  before_action :update_want_offers_status, only: :home
  before_action :set_recommended_offers

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

  # users#home用にcookiesのroaster_idを削除する
  def reset_roaster_id_cookie
    return unless cookies[:roaster_id]

    cookies.delete(:roaster_id)
  end

  # users#home時にwant_offersのステータス更新→1時間置きに実行
  def update_want_offers_status
    return if cookies[:want_update]

    current_user.want_offers&.map(&:update_status)
    cookies[:want_update] = { value: true, expires: 1.hour.from_now }
  end
end
