# # ローカル環境でのテスト
# RSpec.configure do |config|
#   config.before(:each, type: :system) do
#     # Spec実行時、ブラウザが自動で立ち上がり挙動を確認できる
#     # driven_by(:selenium_chrome)

#     # Spec実行時、ブラウザOFF
#     driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
#   end
# end

# Docker環境でのテスト
# RSpec.configure do |config|
#   config.before(:each, type: :system) do
#     driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: {
#       browser: :remote,
#       url: ENV.fetch('SELENIUM_DRIVER_URL'),
#       desired_capabilities: :chrome,
#     }
#     Capybara.server_host = 'web'
#     Capybara.app_host = "http://#{Capybara.server_host}"
#   end
# end
