import axios from 'axios'
import applyCaseMiddleware from 'axios-case-converter'

// applyCaseMiddleware:
// axiosで受け取ったレスポンスの値をスネークケース→キャメルケースに変換
// または送信するリクエストの値をキャメルケース→スネークケースに変換してくれるライブラリ

// ヘッダーに関してはケバブケースのままで良いので適用を無視するオプションを追加
const options = {
  ignoreHeaders: true,
}

const client = applyCaseMiddleware(
  axios.create({
    baseURL: import.meta.env.VITE_API_URL, // 環境変数でURLを読み込む
    headers: {
      'Content-Type': 'application/json',
    },
  }),
  options
)

export default client
