# DSLの読み込みと環境ごとの設定
require 'capistrano/setup'

# デフォルトタスクの読み込み
require 'capistrano/deploy'

# ライブラリ(Git)の読み込み
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# 追加ライブラリの読み込み
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/puma'
install_plugin Capistrano::Puma, load_hooks: false # Default puma tasks without hooks
install_plugin Capistrano::Puma::Systemd
install_plugin Capistrano::Puma::Nginx

# カスタムタスクのインポート
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
