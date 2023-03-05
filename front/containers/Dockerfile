FROM node:16-alpine3.16

ARG WORKDIR

ENV HOME="/${WORKDIR}"\
  LANG=C.UTF-8 \
  TZ=Asia/Tokyo

WORKDIR ${HOME}
COPY package*.json ./
COPY yarn.lock ./

RUN apk update && \
  apk upgrade && \
  yarn install

COPY . ${HOME}

EXPOSE 3000

#コンテナが勝手に終了してしまわないようにする設定
ENV CI=true
