class BeansController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required
  before_action :set_bean, only: %i[show edit update destroy]

  def index
    @pagy, @beans = pagy(current_roaster.beans)
  end

  def show; end

  def new
    @bean = current_roaster.beans.build
  end

  def create
    set_cropped_at
    @bean = current_roaster.beans.build(bean_params)
    if @bean.save
      flash[:notice] = 'コーヒー豆を登録しました'
      redirect_to @bean
    else
      render 'new'
    end
  end

  def edit; end

  def update
    set_cropped_at
    if @bean.update(bean_params)
      flash[:notice] = 'コーヒー豆情報を更新しました'
      redirect_to @bean
    else
      render 'edit'
    end
  end

  def destroy
    @bean.destroy
    flash[:notice] = "コーヒー豆「#{@bean.name}」を削除しました"
    redirect_to beans_path
  end

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
        { images: [] },
        :images_cache,
      )
  end

  def set_bean
    @bean = current_roaster.beans.find_by(id: params[:id])
    redirect_to(root_url) unless @bean
  end

  def set_cropped_at
    params[:bean][:cropped_at] = "#{params[:bean][:cropped_at]}-01"
  end
end
