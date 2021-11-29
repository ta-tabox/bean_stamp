class BeansController < ApplicationController
  MAX_BEANIMAGE_COUNT = 4
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required
  before_action :set_bean, only: %i[show edit update destroy]

  def index
    @pagy, @beans = pagy(current_roaster.beans.includes([:bean_images]))
  end

  def show
    @bean_images = @bean.bean_images.all
  end

  def new
    @bean = current_roaster.beans.build
    @bean_image = @bean.bean_images.build
  end

  def create
    set_cropped_at
    @new_images = params.dig(:bean_images, :image)
    @bean = current_roaster.beans.build(bean_params)
    return if max_bean_images_count_render_for('new')
    if @bean.save
      @new_images.each do |img|
        @bean_image = @bean.bean_images.create(image: img, bean_id: @bean.id)
      end
      flash[:notice] = 'コーヒー豆を登録しました'
      redirect_to @bean
    else
      render 'new'
    end
  end

  def edit
    @bean_images = @bean.bean_images.all
  end

  def update
    set_cropped_at
    @new_images = params.dig(:bean_images, :image)
    return if max_bean_images_count_render_for('edit')

    if @bean.update(bean_params)
      update_bean_images if @new_images
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
        # { images: [] },
        # :images_cache,
        # bean_images_attributes: %i[id bean_id image image_cache],
      )
  end

  def set_bean
    @bean = current_roaster.beans.find_by(id: params[:id])
    redirect_to(root_url) unless @bean
  end

  def set_cropped_at
    params[:bean][:cropped_at] = "#{params[:bean][:cropped_at]}-01"
  end

  # def set_new_images
  #   return unless params.include?(:bean_images)
  #   @new_images = params[:bean_images]['image']
  # end

  def update_bean_images
    bean_images = @bean.bean_images
    bean_images.each(&:destroy)
    @new_images.each do |img|
      @bean.bean_images.create(image: img, bean_id: @bean.id)
    end
  end

  # 登録する画像数を制限し、制限を超える場合viewにレンダリングする
  def max_bean_images_count_render_for(view)
    return unless @new_images && @new_images.length > MAX_BEANIMAGE_COUNT
    @bean.errors.add(
      :bean_images,
      "は #{MAX_BEANIMAGE_COUNT}枚まで登録できます",
    )
    render view
  end
end
