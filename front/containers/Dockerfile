FROM node:16-alpine3.16

ARG WORKDIR
ARG CONTAINER_PORT
ARG API_URL
ARG FRONT_URL

ENV HOME="/${WORKDIR}"\
  LANG=C.UTF-8 \
  TZ=Asia/Tokyo \
  # axiosで叩くAPIのURLを指定
  VITE_API_URL=${API_URL} \
  # ReactアプリケーションのURLを指定
  VITE_FRONT_URL=${FRONT_URL}

WORKDIR ${HOME}
COPY package*.json ./
COPY yarn.lock ./

RUN apk update && \
  apk upgrade && \
  yarn install

COPY . ${HOME}

EXPOSE ${CONTAINER_PORT}

#コンテナが勝手に終了してしまわないようにする設定
ENV CI=true
