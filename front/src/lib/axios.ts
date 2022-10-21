import Axios from 'axios'
import applyCaseMiddleware from 'axios-case-converter'

import { API_URL } from '@/config'

// applyCaseMiddleware:
// axiosで受け取ったレスポンスの値をスネークケース→キャメルケースに変換
// または送信するリクエストの値をキャメルケース→スネークケースに変換してくれるライブラリ

// ヘッダーに関してはケバブケースのままで良いので適用を無視するオプションを追加
const options = {
  ignoreHeaders: true,
}

const axios = applyCaseMiddleware(
  Axios.create({
    baseURL: API_URL,
    headers: {
      'Content-Type': 'application/json',
    },
  }),
  options
)

export default axios
