import type { ChangeEvent, FC } from 'react'
import { useState, memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { useAuth } from '@/hooks/useAuth'
import type { Prefecture } from '@/lib/mstData/prefecture'
import { PrefectureArray } from '@/lib/mstData/prefecture'
import type { SignUpParams } from '@/types/api/user'

export const SignUp: FC = memo(() => {
  const { signUp, loading } = useAuth()
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [prefectureCode, setPrefectureCode] = useState('')
  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')

  const onChangeName = (e: ChangeEvent<HTMLInputElement>) => setName(e.target.value)
  const onChangeEmail = (e: ChangeEvent<HTMLInputElement>) => setEmail(e.target.value)
  const onChangePrefectureCode = (e: ChangeEvent<HTMLSelectElement>) => setPrefectureCode(e.target.value)
  const onChangePassword = (e: ChangeEvent<HTMLInputElement>) => setPassword(e.target.value)
  const onChangePasswordConfirmation = (e: ChangeEvent<HTMLInputElement>) => setPasswordConfirmation(e.target.value)

  const onClickSignUp = (e: React.MouseEvent<HTMLButtonElement>) => {
    e.preventDefault() // formのデフォルトの動きをキャンセルする
    const params: SignUpParams = {
      name,
      email,
      prefectureCode,
      password,
      passwordConfirmation,
    }
    signUp(params)
  }

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインアップ") %>
    // TODO react-hook-formを導入してスッキリさせる, バリデーションを追加する
    <div className="mt-16 flex items-center">
      <div className="form-container">
        <div className="form-main">
          <h1 className="form-title">サインアップ</h1>
          <form>
            {/* 名前 */}
            <div className="input-container">
              <input type="text" className="input-field" placeholder="名前" value={name} onChange={onChangeName} />
            </div>
            {/* メールアドレス */}
            <div className="input-container">
              <input
                type="email"
                className="input-field"
                placeholder="メールアドレス"
                value={email}
                onChange={onChangeEmail}
              />
            </div>
            {/* エリアセレクト */}
            <div className="input-container">
              <select className="input-field" value={prefectureCode} onChange={onChangePrefectureCode}>
                <option value="" selected hidden disabled>
                  エリアを選択してください
                </option>
                {PrefectureArray.map((prefecture: Prefecture) => (
                  <option value={prefecture.id}>{prefecture.label}</option>
                ))}
              </select>
            </div>

            {/* パスワード */}
            <div className="input-container">
              <input
                type="password"
                className="input-field"
                placeholder="パスワード"
                value={password}
                onChange={onChangePassword}
              />
            </div>
            {/* パスワード確認 */}
            <div className="input-container">
              <input
                type="password"
                className="input-field"
                placeholder="パスワード（確認）"
                value={passwordConfirmation}
                onChange={onChangePasswordConfirmation}
              />
            </div>

            <div className="form-button-field mt-4">
              <PrimaryButton
                disabled={!name || !email || !prefectureCode || !password || !passwordConfirmation}
                loading={loading}
                onClick={onClickSignUp}
              >
                登録
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
