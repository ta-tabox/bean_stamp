class Api::HealthCheckController < Api::ApplicationController
  def index
    head :ok
    # NOTE: execTest()によるapiとの疎通確認用 不要になったら消す
    # render json: { status: :ok, message: 'ok' }
  end
end
