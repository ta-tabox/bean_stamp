#!/bin/bash
set -e

rm -f /bean_stamp/tmp/pids/server.pid

# NOTE: migrateする機会がなかったのでうまく機能しているか注意
# コンテナ起動時のdbコマンド
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails db:migrate RAILS_ENV=production
fi

exec "$@"
