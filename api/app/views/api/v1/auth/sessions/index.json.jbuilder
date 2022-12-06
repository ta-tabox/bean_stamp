if @current_user
  json.is_login true
  json.data @current_user, partial: 'api/v1/users/user', as: :user
else
  json.is_login false
  json.message 'ユーザーが存在しません'
end
