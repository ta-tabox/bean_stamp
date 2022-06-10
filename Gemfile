source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.4'
gem 'asset_sync'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cancancan'
gem 'carrierwave', '~> 2.2'
gem 'devise'
gem 'enum_help'
gem 'fog-aws'
gem 'jbuilder', '~> 2.7'
gem 'jp_prefecture', '~> 1.0'
gem 'mini_magick', '~> 4.11'
gem 'mysql2', '~> 0.5'
gem 'pagy', '~> 5.3'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4'
gem 'rails_admin', '~> 3.0'
gem 'rails-i18n', '~> 6.0.0'
gem 'ransack'
gem 'sass-rails', '>= 6'
gem 'seed-fu', '~> 2.3'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'solargraph', require: false
  gem 'spring-commands-rspec'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'bullet'
  gem 'capistrano', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv'
  gem 'ed25519'
  gem 'htmlbeautifier'
  # rails consoleの文字化けを解消する
  gem 'irb', '>= 1.3.6'
  gem 'letter_opener_web', '~> 1.0'
  gem 'listen', '~> 3.3'
  gem 'pre-commit', require: false
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rename'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'launchy'
  gem 'rspec_junit_formatter' # circleciでrspecを取り扱う
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'webdrivers', require: !ENV['SELENIUM_DRIVER_URL']
end
