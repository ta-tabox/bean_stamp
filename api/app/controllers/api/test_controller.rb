class Api::TestController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  # frontとの疎通テスト用のアクション
  def index
    render json: { status: :ok, message: 'Hellow World from API' }
  end
end
