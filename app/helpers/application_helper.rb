module ApplicationHelper
  # ビュー用Pagyモジュールの読み込み→ Vue.js導入時に変更する必要あり
  include Pagy::Frontend

  # 渡されたインスタンスのサムネイルを表示する
  def show_thumbnail(obj)
    image_url = if obj.image?
                  obj.image.thumb.url.to_s
                else
                  "default_#{obj.class.name.downcase}.png"
                end
    image_tag(image_url, class: 'thumbnail', alt: "#{obj.name}の画像")
  end

  def show_bean_thumbnail(bean)
    image_url = if bean.bean_images.any?
                  bean.bean_images[0].image.url.to_s
                else
                  "default_#{bean.class.name.downcase}.png"
                end
    image_tag(image_url, alt: "#{bean.name}の画像", class: 'thumbnail')
  end

  # user, roaster詳細用のimage表示メソッド
  def show_image(obj)
    image_url = if obj.image?
                  obj.image.thumb.url.to_s
                else
                  "default_#{obj.class.name.downcase}.png"
                end
    image_tag(image_url, class: 'object-cover object-center w-full h-48 lg:h-64 rounded-md shadow', alt: "#{obj.name}の画像")
  end

  private

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end

  # 渡されたロースターがカレントロースターであればtrueを返す
  def current_roaster?(roaster)
    roaster && roaster == current_user.roaster
  end
end
