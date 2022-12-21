/* eslint-disable no-console */
import { BackendApi } from '@/lib/axios'

type checkType = {
  status: 'string'
  message: 'string'
}

// 動作確認用
export const execTest = () =>
  BackendApi.get<checkType>('/api/test')
    .then((res) => {
      console.log(res.data)
    })
    .catch((err) => console.log(err))
