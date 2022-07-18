Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # developmentとproductionで許可するオリジン
    origins 'http://localhost:3000', 'https://web.bean-stamp.com'

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
