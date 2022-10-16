import type { FC } from 'react'
import { memo } from 'react'
import { useSearchParams } from 'react-router-dom'

import { PasswordResetForm } from '@/components/organisms/auth/PasswordResetForm'
import { SendPasswordResetMailForm } from '@/components/organisms/auth/SendPasswordResetMailForm'

export const PasswordReset: FC = memo(() => {
  const [searchParams] = useSearchParams()

  // クエリパラメーターからtokenを取得
  const resetPasswordToken = searchParams.get('token')
  const uid = searchParams.get('uid')
  const uClient = searchParams.get('client')
  const accessToken = searchParams.get('access-token')

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "パスワード再設定") %>
    <div className="mt-16 flex items-center">
      {resetPasswordToken && uid && uClient && accessToken ? (
        <PasswordResetForm
          uid={uid}
          uClient={uClient}
          accessToken={accessToken}
          resetPasswordToken={resetPasswordToken}
        />
      ) : (
        <SendPasswordResetMailForm />
      )}
    </div>
  )
})
