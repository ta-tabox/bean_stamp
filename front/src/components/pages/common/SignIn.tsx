import type { FC } from 'react'
import { memo } from 'react'

import { SubmitHandler, useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { useAuth } from '@/hooks/useAuth'
import type { SignInParams } from '@/types/api/user'

export const SignIn: FC = memo(() => {
  const { signIn, loading } = useAuth()

  const {
    register,
    handleSubmit,
    formState: { dirtyFields, errors },
  } = useForm<SignInParams>({ criteriaMode: 'all' })

  const onSubmit: SubmitHandler<SignInParams> = (params) => signIn(params)

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインイン") %>
    <div className="mt-16 flex items-center">
      <div className="form-container">
        <div className="form-main">
          <h1 className="form-title">サインイン</h1>
          {/* TODO formのコンポーネント分割 レンダリングの最適化 */}
          <form onSubmit={handleSubmit(onSubmit)}>
            {/* メールアドレス */}
            <div className="input-container">
              <input
                id="email"
                type="email"
                className="input-field"
                placeholder="email"
                {...register('email', {
                  required: '入力が必須の項目です',
                  pattern: {
                    value: /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]+.[A-Za-z0-9]+$/,
                    message: 'メールアドレスの形式が正しくありません。',
                  },
                })}
              />
              {errors.email?.types?.required && <p role="alert">{errors.email?.types?.required}</p>}
              {errors.email?.types?.pattern && <p role="alert">{errors.email?.types?.pattern}</p>}
            </div>
            {/* パスワード */}
            <div className="input-container">
              <input
                id="password"
                className="input-field"
                placeholder="password"
                type="password"
                {...register('password', {
                  required: '必須項目です',
                  minLength: { value: 6, message: '6文字以上入力してください' },
                  pattern: { value: /^[a-zA-Z0-9!-/:-@¥[-`{-~]+$/, message: '半角英数記号を入力してください' },
                })}
              />
              {errors.password && <p role="alert">{errors.password?.message}</p>}
            </div>
            <div className="form-button-field mt-4">
              <PrimaryButton loading={loading} disabled={!dirtyFields.email || !dirtyFields.password}>
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
