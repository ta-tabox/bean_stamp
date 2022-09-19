class Api::TestController < Api::ApplicationController
  # frontとの疎通テスト用のアクション
  def index
    render json: { status: :ok, message: 'Hellow World from API' }
  end
end
