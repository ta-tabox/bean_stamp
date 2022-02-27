module RoastersHelper
  def link_to_edit_roaster(roaster)
    return unless current_user.belonged_roaster?(roaster)

    link_to '編集', edit_roaster_path, class: 'link'
  end
end
