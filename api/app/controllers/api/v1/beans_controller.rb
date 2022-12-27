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
    bean_params_with_taste_tags = merge_bean_params_with_taste_tag_params
    @bean = current_api_v1_roaster.beans.build(bean_params_with_taste_tags)
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
    bean_params_with_taste_tags = merge_bean_params_with_taste_tag_params
    @bean.upload_images = params.dig(:bean_images, :image)

    if @bean.update_with_bean_images(bean_params_with_taste_tags)
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
      )
  end

  def taste_tag_params
    params
      .require(:taste_tag)
      .permit(
        taste_tag_ids: [],
      )
  end

  def set_bean
    @bean = current_api_v1_roaster.beans.find_by(id: params[:id])
    return if @bean

    render json: { message: 'コーヒー豆を登録してください' }, status: :not_found
  end

  # input type=monthフィールドのデータをdateカラムに保存できる形に変換する
  # e.g. "2021-01" => "2021-01-01"
  def set_cropped_at
    params[:bean][:cropped_at] = "#{params[:bean][:cropped_at]}-01"
  end

  # bean_paramsとtaste_tag_paramsを適切な構造で組み合わせる
  def merge_bean_params_with_taste_tag_params
    taste_tag_ids = params[:taste_tag][:taste_tag_ids]
    bean_taste_tags_attributes = {}
    if @bean
      # update時 中間テーブルbean_taste_tagのidを組みこむ
      bean_taste_tag_ids = @bean&.bean_taste_tag_ids
      taste_tag_ids.each_with_index do |taste_tag_id, index|
        bean_taste_tags_attributes.store(index.to_s, { 'id' => bean_taste_tag_ids[index], 'mst_taste_tag_id' => taste_tag_id })
      end
    else
      # 新規作成時
      taste_tag_ids.each_with_index do |taste_tag_id, index|
        bean_taste_tags_attributes.store(index.to_s, { 'mst_taste_tag_id' => taste_tag_id })
      end
    end
    bean_params.merge({ 'bean_taste_tags_attributes' => bean_taste_tags_attributes })
  end
end