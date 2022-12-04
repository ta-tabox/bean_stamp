class Api::ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken # tokenによる認証をONにする
  # skip_before_action :verify_authenticity_token いらない気がする
  # helper_method :current_user, :user_signed_in? そもそもViewがないのにhelper_methodがいるのか？

  private

  # ユーザーにロースター所属を求める V1
  def user_belonged_to_roaster_required
    return if current_api_v1_user.roaster_id?

    render json: { status: 'error', message: 'ロースターを登録をしてください' }
  end

  # ユーザーにロースター未所属を求める V1
  def user_not_belonged_to_roaster_required
    return unless current_api_v1_user.roaster_id?

    render json: { status: 'error', message: 'ロースターをすでに登録しています' }
  end
end
