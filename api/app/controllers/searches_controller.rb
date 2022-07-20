class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommended_offers
  before_action :set_search_query

  def index
    @active_tab = 'roaster'
  end

  def roaster
    flash.now[:alert] = 'ロースターが見つかりませんでした' unless @roaster_search.result.any?
    @pagy, @roasters = pagy(@roaster_search.result(distinct: true))
    @active_tab = 'roaster'
    render 'index'
  end

  def offer
    flash.now[:alert] = 'オファーが見つかりませんでした' unless @offer_search.result.any?
    offers = @offer_search.result(distinct: true)
    offers&.map(&:update_status)
    @pagy, @offers = pagy(offers.recent.includes(:roaster, { bean: %i[roast_level bean_images taste_tags] }))
    @active_tab = 'offer'
    render 'index'
  end

  private

  def set_search_query
    @roaster_search = Roaster.ransack(params[:roaster_search], search_key: :roaster_search)
    @offer_search = Offer.active.ransack(params[:offer_search], search_key: :offer_search)
  end
end
