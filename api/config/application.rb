require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BeanStamp
  class Application < Rails::Application
    # APIモード専用の場合指定→viewとapiを共存させるためtrueにしない
    # config.api_only = true

    # APIモードでRailsAdminを使用するためにミドルウェアを設定
    # config.middleware.use ActionDispatch::Cookies
    # config.middleware.use ActionDispatch::Flash
    # config.middleware.use Rack::MethodOverride
    # config.middleware.use ActionDispatch::Session::CookieStore, { key: '_bean_stamp_session' }

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # 日本語化
    config.i18n.default_locale = :ja

    # i18nのロケールファイルにpathを通す
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.test_framework :rspec, fixtures: true, view_specs: false, helper_specs: false, routing_specs: false
    end

    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
