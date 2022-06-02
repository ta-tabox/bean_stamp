# Capistranoのバージョンの固定
lock '~> 3.17.0'

# Capistranoのログ表示に利用
set :application, 'bean_stamp'
set :user, 'deploy'

# pullするリポジトリ
set :repo_url, 'git@github.com:tanktabox/bean_stamp.git'

# Default branch is :master
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/bean_stamp'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/credentials/production.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor', 'storage', 'node_modules'

# 出力するログレベル
set :log_level, :debug

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# 保持するリリース数
set :keep_releases, 3

# デプロイ先のサーバーにインストールされているrubyバージョン
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# puma
set :puma_init_active_record, true

# Nginxの設定ファイル名と置き場所を修正
set :nginx_config_name, "#{fetch(:application)}.conf"
set :nginx_sites_enabled_path, '/etc/nginx/conf.d'
