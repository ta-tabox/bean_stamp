import Axios from 'axios'
import applyCaseMiddleware from 'axios-case-converter'
import { Cookies } from 'react-cookie'

import { API_ORIGIN } from '@/config'

// applyCaseMiddleware:
// axiosで受け取ったレスポンスの値をスネークケース→キャメルケースに変換
// または送信するリクエストの値をキャメルケース→スネークケースに変換してくれるライブラリ
// ヘッダーに関してはケバブケースのままで良いので適用を無視するオプションを追加
const options = {
  ignoreHeaders: true,
}

const createAxiosInstance = () => {
  // applyCaseMiddlewareの機能を持つaxiosインスタンスを作成
  const axiosInstance = applyCaseMiddleware(
    Axios.create({
      // apiのURLを指定
      baseURL: `${API_ORIGIN}/api/v1`,
      headers: {
        'Content-Type': 'application/json',
      },
    }),
    options
  )
  return axiosInstance
}

// 認証Headersなしのaxiosインスタンスを作成
export const BackendApi = createAxiosInstance()

// 認証Header付きのaxiosインスタンスを作成
export const BackendApiWithAuth = createAxiosInstance()

// interceptors.requestでリクエスト実行時のアクションを定義
// api認証で使用するtokenをheadersに設定する
// cookieからAPI認証用のトークンを取得し、axiosのheaderとして使用する
const cookies = new Cookies()

BackendApiWithAuth.interceptors.request.use((request) => {
  if (request.headers) {
    request.headers.uid = cookies.get('uid') as string | ''
    request.headers.client = cookies.get('client') as string | ''
    request.headers['access-token'] = cookies.get('access-token') as string | ''
  }
  return request
})
