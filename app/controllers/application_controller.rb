class ApplicationController < ActionController::Base
  private

  # ユーザーのサインインを求める
  def user_signed_in_required
    redirect_to new_user_session_url unless user_signed_in?
  end

  # ユーザーにロースター所属を求める
  def belonged_to_roaster_required
    if current_user.roaster_id?
      @roaster = current_roaster
    else
      flash[:alert] = 'ロースター登録をしてください'
      redirect_to(root_url)
    end
  end

  # ログイン中のユーザーが所属するロースターを返す
  def current_roaster
    current_user.roaster
  end
end
