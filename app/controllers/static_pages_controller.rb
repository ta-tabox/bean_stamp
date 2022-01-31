class StaticPagesController < ApplicationController
  def home
    # ログインしているかどうかで処理を切り替える
    redirect_to(home_users_path) if user_signed_in?
  end

  def help; end

  def about; end
end
