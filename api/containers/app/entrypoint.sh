#!/bin/bash
set -e

rm -f /bean_stamp/tmp/pids/server.pid

# コンテナ起動時のdbコマンド
if [ "$RAILS_ENV" = "production" ]; then
  # bundle exec rails db:create RAILS_ENV=production # 初回のみ実行
  bundle exec rails db:migrate RAILS_ENV=production
  # bundle exec rails db:seed RAILS_ENV=production # 初回のみ実行
fi

exec "$@"
