class BeansController < ApplicationController
  before_action :user_signed_in_required
  before_action :user_belonged_to_roaster_required
  before_action :set_bean, only: %i[show edit update destroy]

  def index
    @pagy, @beans = pagy(current_roaster.beans.includes([:bean_images]))
  end

  def show; end

  def new
    @bean = current_roaster.beans.build
    @upload_image = @bean.bean_images.build
    3.times { @bean.bean_taste_tags.build }
  end

  def create
    set_cropped_at
    @bean = current_roaster.beans.build(bean_params)
    @bean.upload_images = params.dig(:bean_images, :image)

    if @bean.save
      @bean.upload_images.each do |img|
        @bean_image = @bean.bean_images.create(image: img, bean_id: @bean.id)
      end
      flash[:notice] = 'コーヒー豆を登録しました'
      redirect_to @bean
    else
      @upload_image = @bean.bean_images.build
      render 'new'
    end
  end

  def edit
    @upload_image = @bean.bean_images.build
  end

  def update
    set_cropped_at
    @bean.upload_images = params.dig(:bean_images, :image)

    if @bean.update_with_bean_images(bean_params)
      flash[:notice] = 'コーヒー豆情報を更新しました'
      redirect_to @bean
    else
      @upload_image = @bean.bean_images.build
      render 'edit'
    end
  end

  def destroy
    @bean.destroy
    flash[:notice] = "コーヒー豆「#{@bean.name}」を削除しました"
    redirect_to beans_path
  end

  private

  # rubocop:disable all
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
        :roast_level_id,
        bean_taste_tags_attributes: %i[id user_id mst_taste_tag_id],
      )
  end

  # rubocop:disable all

  def set_bean
    return if @bean = current_roaster.beans.find_by(id: params[:id])
    redirect_to beans_path, alert: 'コーヒー豆を登録してください'
  end

  # input type=monthフィールドのデータをdateカラムに保存できる形に変換する
  # e.g. "2021-01" => "2021-01-01"
  def set_cropped_at
    params[:bean][:cropped_at] = "#{params[:bean][:cropped_at]}-01"
  end
end
