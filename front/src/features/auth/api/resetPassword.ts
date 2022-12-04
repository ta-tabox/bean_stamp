import type { PasswordResetHeaders, PasswordResetParams } from '@/features/auth/types'
import axios from '@/lib/axios'

type Options = {
  headers: PasswordResetHeaders
  params: PasswordResetParams
}

export const resetPassword = ({ headers, params }: Options) => {
  const { uid, client, accessToken, resetPasswordToken } = headers

  return axios.put('auth/password', params, {
    headers: {
      uid,
      client,
      'access-token': accessToken,
      reset_password_token: resetPasswordToken,
    },
  })
}
