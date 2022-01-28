module ApplicationHelper
  # ビュー用Pagyモジュールの読み込み→ Vue.js導入時に変更する必要あり
  include Pagy::Frontend

  # 渡されたインスタンスのサムネイルを表示する
  def show_thumbnail(obj)
    if obj.instance_of?(Bean)
      show_bean_thumbnail(obj)
    else
      show_user_roaster_thumbnail(obj)
    end
  end

  private

  # beanの画像を表示する（複数画像のうち最初のもの）
  def show_bean_thumbnail(obj)
    if obj.bean_images.any? && obj.bean_images[0].image?
      link_to image_tag(
        obj.bean_images[0].image.thumb.url.to_s,
        class: 'thumbnail',
        alt: "#{obj.name}の画像",
      ),
              obj
    else
      link_to image_tag(
        "default_#{obj.class.name.downcase}.png",
        class: 'thumbnail',
        alt: "#{obj.name}の画像",
      ),
              obj
    end
  end

  # userとroasterの画像を表示する
  def show_user_roaster_thumbnail(obj)
    if obj.image?
      link_to image_tag(
        obj.image.thumb.url.to_s,
        class: 'thumbnail',
        alt: "#{obj.name}の画像",
      ),
              obj
    else
      link_to image_tag(
        "default_#{obj.class.name.downcase}.png",
        class: 'thumbnail',
        alt: "#{obj.name}の画像",
      ),
              obj
    end
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end

  # 渡されたロースターがカレントロースターであればtrueを返す
  def current_roaster?(roaster)
    roaster && roaster == current_user.roaster
  end
end
