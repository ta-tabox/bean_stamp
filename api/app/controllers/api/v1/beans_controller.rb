class Api::V1::BeansController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_belonged_to_roaster_required
  before_action :set_bean, only: %i[show update destroy]

  def index
    @beans = current_api_v1_roaster.beans.includes(%i[bean_images country roast_level]).recent
    render formats: :json
  end

  def show
    render formats: :json
  end

  def create
    set_cropped_at
    @bean = current_api_v1_roaster.beans.build(bean_params)
    @bean.upload_images = params.dig(:bean_images, :image)

    if @bean.save
      @bean.upload_images.each do |img|
        @bean_image = @bean.bean_images.create(image: img, bean_id: @bean.id)
      end
      render formats: :json
    else
      render json: { messages: @bean.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    set_cropped_at
    @bean.upload_images = params.dig(:bean_images, :image)

    if @bean.update_with_bean_images(bean_params)
      render formats: :json
    else
      render json: { messages: @bean.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @bean.offers.any?
      return render json: { message: "コーヒー豆「#{@bean.name}」はオファー中です" }, status: :method_not_allowed
    end

    if @bean.destroy
      render json: { message: 'コーヒー豆を削除しました' }, status: :ok
    else
      render json: { message: 'コーヒー豆の削除に失敗しました' }, status: :method_not_allowed
    end
  end

  private

  # rubocop:disable all
  def bean_params
    params
      .require(:bean)
      .permit(
        :name,
        :country_id,
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
        bean_taste_tags_attributes: %i[id mst_taste_tag_id],
      )
  end

  def set_bean
    return if @bean = current_api_v1_roaster.beans.find_by(id: params[:id])
    render json: {  message: 'コーヒー豆を登録してください' }, status: :not_found
  end

  # input type=monthフィールドのデータをdateカラムに保存できる形に変換する
  # e.g. "2021-01" => "2021-01-01"
  def set_cropped_at
    params[:bean][:cropped_at] = "#{params[:bean][:cropped_at]}-01"
  end
end
