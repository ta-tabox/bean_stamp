class ApplicationController < ActionController::Base
  # Pagyによるpagination
  include Pagy::Backend

  private

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

  # ロースター用のクッキーを作成する
  def set_roaster_id_cookie
    cookies[:roaster_id] = current_user.roaster.id
  end

  # ログイン中のユーザーが所属するロースターを返す
  def current_roaster
    current_user.roaster
  end
end
