Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # developmentとproductionで環境変数を変える
    origins ENV['API_DOMAIN'] || ''

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
