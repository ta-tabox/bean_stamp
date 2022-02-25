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
    link_to image_tag(image_url, class: 'thumbnail', alt: "#{obj.name}の画像"), obj
  end

  def show_bean_thumbnail(bean)
    image_url = if bean.bean_images.any?
                  bean.bean_images[0].image.url.to_s
                else
                  "default_#{bean.class.name.downcase}.png"
                end
    image_tag(image_url, alt: "#{bean.name}の画像", class: 'thumbnail')
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
