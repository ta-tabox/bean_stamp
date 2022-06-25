#!/bin/bash
set -e

rm -f /bean_stamp/tmp/pids/server.pid

# コンテナ起動時のdbコマンド
# bundle exec rails db:create RAILS_ENV=production # EC2デプロイ時に実行済み
bundle exec rails db:migrate RAILS_ENV=production
# bundle exec rails db:seed RAILS_ENV=production # EC2デプロイ時に実行済み

exec "$@"
