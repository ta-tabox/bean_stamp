class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def roaster
    @q = Roaster.ransack(params[:q])
    flash.now[:alert] = 'ロースターが見つかりませんでした' unless @q.result.any?
    @pagy, @roasters = pagy(@q.result(distinct: true))
  end

  def offer
    @q = Offer.ransack(params[:q])
    @offers = @q.result(distinct: true)
  end
end
