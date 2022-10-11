class Api::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken # tokenによる認証をONにする

  # skip_before_action :verify_authenticity_token いらない気がする
  # helper_method :current_user, :user_signed_in? そもそもViewがないのにhelper_methodがいるのか？
end
