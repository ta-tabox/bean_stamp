class ApplicationController < ActionController::Base
  # Pagyによるpagination
  include Pagy::Backend

  private

  # ユーザーのサインインを求める
  def user_signed_in_required
    redirect_to new_user_session_url, alert: 'ログインもしくはアカウント登録してください。' unless user_signed_in?
  end

  # ユーザーにロースター所属を求める
  def user_belonged_to_roaster_required
    return if current_user.roaster_id?

    flash[:alert] = 'ロースターを登録をしてください'
    redirect_to(root_url)
  end

  # ユーザーにロースター未所属を求める
  def user_not_belonged_to_roaster_required
    return unless current_user.roaster_id?

    flash[:alert] = 'ロースターをすでに登録しています'
    redirect_to(root_url)
  end

  # ログイン中のユーザーが所属するロースターを返す
  def current_roaster
    current_user.roaster
  end

  # offers, wantsのselect_box用にstatus_listを配列化, [key, value] ->[value, key]
  def set_search_index_for_offer_status
    status_list = Offer.status_list.map { |k, v| [v, k] }
    @search_index = status_list.to_a
  end
end
