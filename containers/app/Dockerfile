FROM ruby:3.0.4

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV}

ENV HOME="/bean_stamp" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# yarnパッケージ管理ツールをインストール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# 必要なパッケージインストール
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    yarn \
    default-mysql-client \
    imagemagick

WORKDIR ${HOME}
COPY Gemfile ${HOME}/Gemfile
COPY Gemfile.lock ${HOME}/Gemfile.lock
RUN bundle install
COPY . ${HOME}

RUN yarn install --check-files
RUN bundle exec rails webpacker:compile

# コンテナ起動時に実行させるスクリプトを追加
COPY containers/app/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

VOLUME /${HOME}/public
VOLUME /${HOME}/tmp

CMD /bin/sh -c "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma/production.rb"
