class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @roasters_q = Roaster.ransack(params[:roasters_q], search_key: :roasters_q)
    @pagy, @roasters = pagy(@roasters_q.result(distinct: true))
  end

  def roaster
    @roasters_q = Roaster.ransack(params[:roasters_q], search_key: :roasters_q)
    flash.now[:alert] = 'ロースターが見つかりませんでした' unless @roasters_q.result.any?
    @pagy, @roasters = pagy(@roasters_q.result(distinct: true))
  end

  # def offer
  #   @q = Offer.ransack(params[:q])
  #   @offers = @q.result(distinct: true)
  # end
end
