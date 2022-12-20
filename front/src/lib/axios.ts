import Axios from 'axios'
import applyCaseMiddleware from 'axios-case-converter'
import { Cookies } from 'react-cookie'

import { API_HOST } from '@/config'

// applyCaseMiddleware:
// axiosで受け取ったレスポンスの値をスネークケース→キャメルケースに変換
// または送信するリクエストの値をキャメルケース→スネークケースに変換してくれるライブラリ

// ヘッダーに関してはケバブケースのままで良いので適用を無視するオプションを追加
const options = {
  ignoreHeaders: true,
}

// cookieからAPI認証用のトークンを取得し、axiosのheaderとして使用する
const cookies = new Cookies()
const authHeaders = {
  uid: cookies.get('uid') as string | '',
  client: cookies.get('client') as string | '',
  'access-token': cookies.get('access-token') as string | '',
}

const axios = applyCaseMiddleware(
  Axios.create({
    baseURL: `${API_HOST}/api/v1`,
    headers: {
      'Content-Type': 'application/json',
      ...authHeaders,
    },
  }),
  options
)

export default axios
