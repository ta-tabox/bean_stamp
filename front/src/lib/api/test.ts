/* eslint-disable no-console */
import client from '@/lib/api/client'

type checkType = {
  status: 'string'
  message: 'string'
}

// 動作確認用
export const execTest = () =>
  client
    .get<checkType>('/api/test')
    .then((res) => {
      console.log(res.data)
    })
    .catch((err) => console.log(err))
