import type { ChangeEvent, FC } from 'react'
import { useState, memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { useAuth } from '@/hooks/useAuth'

export const SignIn: FC = memo(() => {
  const { login, loading } = useAuth()
  const [userId, setUserId] = useState('')

  const onChangeUserId = (e: ChangeEvent<HTMLInputElement>) => setUserId(e.target.value)

  const onClickLogin = () => login(userId)

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインイン") %>
    <div className="mt-16 flex items-center">
      <div className="form-container">
        <div className="form-main">
          <h1 className="form-title">サインイン</h1>
          <div className="input-container">
            <input
              type="text"
              className="input-field"
              placeholder="ユーザーID"
              value={userId}
              onChange={onChangeUserId}
            />
          </div>
          <div className="form-button-field mt-4">
            <PrimaryButton disabled={userId === ''} loading={loading} onClick={onClickLogin}>
              ログイン
            </PrimaryButton>
          </div>
        </div>
        <div className="form-footer">
          <h1>フォームフッター</h1>
        </div>
      </div>
    </div>
  )
})
