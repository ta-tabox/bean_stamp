Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # developmentとproductionで環境変数を変える
    # developmentはdocker-compose.ymlに記述
    # productionはcredentialsで定義
    origins Rails.application.credentials.dig(:aws, :front_origin) || ''

    resource '*', # 全てのリソースに以下を許可
             headers: :any, # APIサーバに対するリクエストにどんなヘッダでもつけることを許可
             expose: %w[access-token expiry token-type uid client link current-page page-items total-pages total-count], # レスポンスのHTTPヘッダとして公開を許可する
             methods: %i[get post put patch delete options head], # 指定したメソッドでのリソースへのアクセスを許可する
             credentials: true
  end
end
