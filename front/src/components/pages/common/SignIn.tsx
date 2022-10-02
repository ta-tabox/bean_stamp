import type { ChangeEvent, FC } from 'react'
import { useState, memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { useAuth } from '@/hooks/useAuth'
import type { SignInParams } from '@/types/api/user'

export const SignIn: FC = memo(() => {
  const { signIn, loading } = useAuth()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const onChangeEmail = (e: ChangeEvent<HTMLInputElement>) => setEmail(e.target.value)
  const onChangePassword = (e: ChangeEvent<HTMLInputElement>) => setPassword(e.target.value)

  const onClickSignIn = (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault() // formのデフォルトの動きをキャンセルする
    const params: SignInParams = {
      email,
      password,
    }
    signIn(params)
  }

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインイン") %>
    <div className="mt-16 flex items-center">
      <div className="form-container">
        <div className="form-main">
          <h1 className="form-title">サインイン</h1>
          <form>
            {/* メールアドレス */}
            <div className="input-container">
              <input type="email" className="input-field" placeholder="email" value={email} onChange={onChangeEmail} />
            </div>
            {/* パスワード */}
            <div className="input-container">
              <input
                type="password"
                className="input-field"
                placeholder="password"
                value={password}
                onChange={onChangePassword}
              />
            </div>
            <div className="form-button-field mt-4">
              <PrimaryButton disabled={!email || !password} loading={loading} onClick={onClickSignIn}>
                ログイン
              </PrimaryButton>
            </div>
          </form>
        </div>
        <div className="form-footer">
          <h1>フォームフッター</h1>
        </div>
      </div>
    </div>
  )
})
