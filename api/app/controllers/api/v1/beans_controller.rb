class Api::V1::BeansController < Api::ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_belonged_to_roaster_required
  before_action :set_roaster_id_cookie, only: %i[index show]
  before_action :set_bean, only: %i[show update destroy]

  # TODO: Jsonでコーヒー豆一覧を返す
  def index
    @beans = current_api_v1_roaster.beans.includes(%i[bean_images country roast_level]).recent
  end

  # TODO: JSONでコーヒー豆単体を返す
  def show; end

  # TODO: paramsを元にコーヒー豆レコードを作成→JSONで登録したコーヒー豆を返す
  def create
    # TODO: front側でinput type=monthフィールドのデータをdateカラムに保存できる形に変換する
    # e.g. "2021-01" => "2021-01-01"
    # set_cropped_at
    @bean = current_api_v1_roaster.beans.build(bean_params)
    @bean.upload_images = params.dig(:bean_images, :image)

    if @bean.save
      @bean.upload_images.each do |img|
        @bean_image = @bean.bean_images.create(image: img, bean_id: @bean.id)
      end
      flash[:notice] = 'コーヒー豆を登録しました' # 不要
      redirect_to @bean # @beanのパーシャルを作成
    else
      @upload_image = @bean.bean_images.build # 不要
      render 'new' # 不要 エラーメッセージを返す
    end
  end

  def update
    # TODO: front側でinput type=monthフィールドのデータをdateカラムに保存できる形に変換する
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

  # TODOレコードの削除、messageとstatusのみ返却
  def destroy
    if @bean.offers.any?
      redirect_to request.referer, alert: "コーヒー豆「#{@bean.name}」はオファー中です"
    else
      @bean.destroy
      flash[:notice] = "コーヒー豆「#{@bean.name}」を削除しました"
      redirect_to beans_path
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
        bean_taste_tags_attributes: %i[id user_id mst_taste_tag_id],
      )
  end

  def set_bean
    return if @bean = current_api_v1_roaster.beans.find_by(id: params[:id])
    redirect_to beans_path, alert: 'コーヒー豆を登録してください'
  end

  # input type=monthフィールドのデータをdateカラムに保存できる形に変換する
  # e.g. "2021-01" => "2021-01-01"
  # def set_cropped_at
  #   params[:bean][:cropped_at] = "#{params[:bean][:cropped_at]}-01"
  # end
end
