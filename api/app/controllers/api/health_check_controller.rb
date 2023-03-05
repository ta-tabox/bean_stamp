class Api::HealthCheckController < Api::ApplicationController
  def index
    head :ok
  end
end
