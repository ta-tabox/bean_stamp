module WantsHelper
  def show_bean_image(bean)
    image_url = if bean.bean_images.any?
                  bean.bean_images[0].image.url.to_s
                else
                  "default_#{bean.class.name.downcase}.png"
                end
    image_tag(image_url, alt: "#{bean.name}の画像", class: 'object-cover w-20 h-20 border-2 border-blue-500 rounded-full')
  end
end
