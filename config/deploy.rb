# Capistranoのバージョンの固定
lock '~> 3.17.0'

# Capistranoのログ表示に利用
set :application, 'bean_stamp'
set :user, 'deploy'

# pullするリポジトリ
set :repo_url, 'git@github.com:tanktabox/bean_stamp.git'
set :branch, ENV['BRANCH'] || 'master'
set :deploy_to, '/var/www/bean_stamp'

# リリース間で共有するファイル、フォルダ
append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/webpacker', 'public/system', 'vendor', 'storage', 'node_modules'

# 出力するログレベル
set :log_level, :debug

# 保持するリリース数
set :keep_releases, 3

# デプロイ先のサーバーにインストールされているrubyバージョン
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# puma
set :puma_init_active_record, true

# Nginxの設定ファイル名と置き場所を修正
set :nginx_config_name, "#{fetch(:application)}.conf"
set :nginx_sites_enabled_path, '/etc/nginx/conf.d'

# ローカルにてプリコンパイル→本番環境にデプロイ
namespace :deploy do
  # capistranoを実行したマシン側でコンパイルする
  task :compile_assets_locally do
    run_locally do
      with rails_env: fetch(:stage) do
        execute 'bundle exec rails assets:precompile RAILS_ENV=production'
      end
    end
  end

  # webpackerとsprocketsで生成したファイルをそれぞれzipする
  task :zip_assets_locally do
    run_locally do
      execute 'tar -zcvf ./tmp/assets.tar.gz ./public/assets 1> /dev/null'
      execute 'tar -zcvf ./tmp/packs.tar.gz ./public/packs 1> /dev/null'
    end
  end

  # zip後のファイルをupload!でWebサーバーに送り込む
  task :send_assets_zip do
    on roles(:web) do |_host|
      upload!('./tmp/assets.tar.gz', "#{release_path}/public/")
      upload!('./tmp/packs.tar.gz', "#{release_path}/public/")
    end
  end

  # Webサーバー内でunzipする
  task :unzip_assets do
    on roles(:web) do |_host|
      execute "cd #{release_path}; tar -zxvf #{release_path}/public/assets.tar.gz 1> /dev/null"
      execute "cd #{release_path}; tar -zxvf #{release_path}/public/packs.tar.gz 1> /dev/null"
    end
  end
end

# タスクの呼び出し
before 'deploy:updated', 'deploy:compile_assets_locally'
before 'deploy:updated', 'deploy:zip_assets_locally'
before 'deploy:updated', 'deploy:send_assets_zip'
before 'deploy:updated', 'deploy:unzip_assets'
