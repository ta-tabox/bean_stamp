import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { FormContainer } from '@/components/atoms/form/FormContainer'
import { FormFooter } from '@/components/atoms/form/FormFooter'
import { FormMain } from '@/components/atoms/form/FormMain'
import { FormTitle } from '@/components/atoms/form/FormTitle'
import { EmailInput } from '@/components/molecules/user/EmailInput'
import { PasswordInput } from '@/components/molecules/user/PasswordInput'
import { useAuth } from '@/hooks/useAuth'
import type { SignInParams } from '@/types/api/user'

import type { SubmitHandler } from 'react-hook-form'

// react-hook-formで取り扱うデータの型
export type SignInSubmitData = {
  params: SignInParams
  rememberMe?: boolean
}

export const SignIn: FC = memo(() => {
  const { signIn, loading } = useAuth()

  const {
    register,
    handleSubmit,
    formState: { dirtyFields, errors },
  } = useForm<SignInSubmitData>({ criteriaMode: 'all' })

  const onSubmit: SubmitHandler<SignInSubmitData> = (data) => {
    const { params, rememberMe } = data
    signIn(params, rememberMe)
  }

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインイン") %>
    <div className="mt-16 flex items-center">
      <FormContainer>
        <FormMain>
          <FormTitle>サインイン</FormTitle>
          <form onSubmit={handleSubmit(onSubmit)}>
            {/* メールアドレス */}
            <EmailInput label="params.email" register={register} error={errors.params?.email} />
            {/* パスワード */}
            <PasswordInput
              label="params.password"
              placeholder="パスワード"
              register={register}
              error={errors.params?.password}
            />

            {/* remember me */}
            <div className="mt-2 ml-2 flex items-center align-middle">
              <input id="rememberMe" type="checkbox" className="cursor-pointer" {...register('rememberMe')} />
              <label htmlFor="rememberMe" className="cursor-pointer text-gray-600 pl-3">
                ログインを記録する
              </label>
            </div>

            <div className="flex items-center justify-center mt-4">
              <PrimaryButton loading={loading} disabled={!dirtyFields.params?.email || !dirtyFields.params.password}>
                ログイン
              </PrimaryButton>
            </div>
          </form>
        </FormMain>
        {/* TODO パスワード再設定、サインアップへの導線、ゲストログイン */}
        <FormFooter>
          <h4 className="pb-2">パスワードを忘れましたか？ パスワード再設定</h4>
          <h4>アカウントをお持ちではありませんか？</h4>
          <Link to="/signUp" className="ml-2 link">
            サインアップ
          </Link>
          <h4 className="pt-4 text-center text-sm text-gray-800 font-light">閲覧用</h4>
          <div>
            <div className="flex justify-center">
              <h4>ゲストログイン</h4>
            </div>
          </div>
        </FormFooter>
      </FormContainer>
    </div>
  )
})
