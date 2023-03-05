module AuthorizationSpecHelper
  def sign_in_with_token(user)
    post api_v1_user_session_path,
         params: { email: user.email, password: user.password },
         as: :json

    # レスポンスのHeadersからトークン認証に必要な要素を抜き出して返す処理
    response.headers.slice('client', 'access-token', 'uid')
  end
end
