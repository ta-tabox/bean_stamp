#!/bin/sh
set -ex

IP=`curl -f -s ifconfig.me`

# シグナル(0,1,2,3,15)を受け取ってセキュリティグループからIPを削除する
trap "aws ec2 revoke-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 22 --cidr ${IP}/32" 0 1 2 3 15
# CircleCI実行環境のIPをセキュリティグループに追加する
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 22 --cidr ${IP}/32
bundle exec cap production deploy
