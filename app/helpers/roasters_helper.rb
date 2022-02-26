module RoastersHelper
  def show_image(roaster)
    image_url = if roaster.image?
                  roaster.image.thumb.url.to_s
                else
                  "default_#{roaster.class.name.downcase}.png"
                end
    image_tag(image_url, class: 'object-cover object-center w-full h-48 lg:h-64 rounded-md shadow', alt: "#{roaster.name}の画像")
  end

  def link_to_edit(roaster)
    return unless current_user.belonged_roaster?(roaster)

    link_to '編集', edit_roaster_path, class: 'link'
  end
end
