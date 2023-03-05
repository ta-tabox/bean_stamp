class StaticPagesController < ApplicationController
  def home
    redirect_to(home_users_path) if user_signed_in?
  end

  def help; end

  def about; end
end
