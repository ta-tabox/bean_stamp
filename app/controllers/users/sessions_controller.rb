# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'static_pages', only: [:new]
  # before_action :configure_sign_in_params, only: [:create]

  # ゲストログイン
  def guest_sign_in
    guest_user = User.find_by(guest: true)
    sign_in guest_user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end
  # POST /resource/sign_in
  # def create
  #   super
  # end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  # protected
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
