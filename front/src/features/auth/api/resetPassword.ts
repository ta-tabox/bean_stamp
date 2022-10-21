import type { PasswordResetHeaders, PasswordResetParams } from '@/features/auth/types'
import axios from '@/lib/axios'

export const resetPassword = (headers: PasswordResetHeaders, params: PasswordResetParams) => {
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
