/* eslint-disable no-console */
import axios from '@/lib/axios'

type checkType = {
  status: 'string'
  message: 'string'
}

// 動作確認用
export const execTest = () =>
  axios
    .get<checkType>('/api/test')
    .then((res) => {
      console.log(res.data)
    })
    .catch((err) => console.log(err))
