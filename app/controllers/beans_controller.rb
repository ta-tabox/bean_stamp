class BeansController < ApplicationController
  before_action :set_roaster

  def index
    @beans = @roaster.beans
  end

  def show
    @bean = @roaster.beans.find(params[:id])
  end

  def new
    @bean = @roaster.beans.build
  end

  def create
    @bean = @roaster.beans.build(bean_params)
    if @bean.save
      flash[:notice] = 'コーヒー豆を登録しました'
      redirect_to @bean
    else
      render 'new'
    end
  end

  def edit; end

  private

  def bean_params
    params
      .require(:bean)
      .permit(
        :name,
        :country,
        :subregion,
        :farm,
        :variety,
        :elevation,
        :process,
        :cropped_at,
        :describe,
        :acidity,
        :flavor,
        :body,
        :bitterness,
        :sweetness,
      )
  end

  def set_roaster
    @roaster = current_user.roaster
  end
end
