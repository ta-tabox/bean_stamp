import type { FC } from 'react'
import { memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { useAuth } from '@/hooks/useAuth'
import type { SignUpParams } from '@/types/api/user'
import { FormContainer } from '@/components/atoms/form/FormContainer'
import { FormMain } from '@/components/atoms/form/FormMain'
import { FormTitle } from '@/components/atoms/form/FormTitle'
import { FieldError, SubmitHandler, useForm } from 'react-hook-form'
import { EmailInput } from '@/components/molecules/user/EmailInput'
import { PasswordInput } from '@/components/molecules/user/PasswordInput'
import { UserNameInput } from '@/components/molecules/user/UserNameInput'
import { PrefectureOption, PrefectureSelect } from '@/components/molecules/user/PrefectureSelect'

// react-hook-formで取り扱うデータの型
type SignUpSubmitData = SignUpParams & {
  prefectureOption: PrefectureOption
}

export const SignUp: FC = memo(() => {
  const { signUp, loading } = useAuth()

  const {
    register,
    handleSubmit,
    formState: { dirtyFields, errors },
    control,
  } = useForm<SignUpSubmitData>({ criteriaMode: 'all' })

  const onSubmit: SubmitHandler<SignUpSubmitData> = (data) => {
    const params: SignUpParams = {
      name: data.name,
      email: data.email,
      prefectureCode: data.prefectureOption.value.toString(),
      password: data.password,
      passwordConfirmation: data.passwordConfirmation,
    }
    signUp(params)
  }

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインアップ") %>
    <div className="mt-16 flex items-center">
      <FormContainer>
        <FormMain>
          <FormTitle>サインアップ</FormTitle>
          <form onSubmit={handleSubmit(onSubmit)}>
            {/* 名前 */}
            <UserNameInput label="name" register={register} error={errors.name} />

            {/* メールアドレス */}
            <EmailInput label="email" register={register} error={errors.email} />

            {/* エリアセレクト */}
            <PrefectureSelect
              label="prefectureOption"
              control={control}
              error={errors.prefectureOption as FieldError}
            />

            {/* パスワード */}
            <PasswordInput
              label="password"
              placeholder="パスワード *6文字以上"
              register={register}
              error={errors.password}
            />

            {/* パスワード確認 */}
            <PasswordInput
              label="passwordConfirmation"
              placeholder="パスワード(確認)"
              register={register}
              error={errors.passwordConfirmation}
            />

            <div className="flex items-center justify-center mt-4">
              <PrimaryButton
                disabled={
                  !dirtyFields.name ||
                  !dirtyFields.email ||
                  !dirtyFields.prefectureOption ||
                  !dirtyFields.password ||
                  !dirtyFields.passwordConfirmation
                }
                loading={loading}
              >
                登録
              </PrimaryButton>
            </div>
          </form>
        </FormMain>
        <div className="form-footer">
          <h1>フォームフッター</h1>
        </div>
      </FormContainer>
    </div>
  )
})
