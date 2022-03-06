module Users::UsersHelper
  def link_to_edit_user(user)
    return unless current_user == user

    link_to '編集', edit_user_registration_path, class: 'link'
  end
end
