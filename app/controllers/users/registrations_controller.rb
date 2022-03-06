# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # rubocop:disable all
  layout 'static_pages', only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: %i[update]

  prepend_before_action :require_no_authentication, only: %i[new create]
  prepend_before_action :authenticate_scope!,
                        only: %i[edit update destroy cancel]
  before_action :ensure_normal_user, only: %i[update destroy]

  # prepend_before_action :set_minimum_password_length,
  #                       only: %i[new edit]

  # rubocop:disable all

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   # super
  # end

  # PUT /resource
  # def update; end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def cancel; end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name prefecture_code])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[name prefecture_code describe roaster_id image image_cache],
    )
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # super(resource)-> ユーザー編集ページ
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  # パスワードなしでupdateできるようにする
  def update_resource(resource, params)
    unless params[:password].blank?
      resource.update_with_password(params)
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  # ゲストユーザーの編集・削除を制限する
  def ensure_normal_user
    if @user.guest?
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません'
    end
  end
end
