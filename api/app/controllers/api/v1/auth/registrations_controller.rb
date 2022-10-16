# frozen_string_literal: true
# rubocop:disable all

# DeviseTokenAuthのRegistration関係のコントローラを上書き
class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  wrap_parameters format: [] # parameterのフォーマットをキャンセル

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: %i[update]

  private

  # deviseで取り扱うparameterの設定
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name prefecture_code])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[name prefecture_code describe roaster_id image],
    )
  end

  # railsのストロングパラメーターの設定
  #ユーザー登録時に使用
  def sign_up_params
      params.permit(:name,:email, :password, :password_confirmation,:prefecture_code)
  end

  #ユーザー更新時に使用
  def account_update_params
      params.permit(:name,:email, :password, :password_confirmation,:prefecture_code, :describe, :image)
  end
end
