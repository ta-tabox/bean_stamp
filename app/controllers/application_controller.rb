class ApplicationController < ActionController::Base
  private

  # ユーザーのサインインを求める
  def user_signed_in_required
    redirect_to new_user_session_url unless user_signed_in?
  end
end
