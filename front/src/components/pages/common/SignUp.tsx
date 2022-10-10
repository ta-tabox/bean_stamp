import type { FC } from 'react'
import { memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { useAuth } from '@/hooks/useAuth'
import type { Prefecture } from '@/lib/mstData/prefecture'
import { PrefectureArray } from '@/lib/mstData/prefecture'
import type { SignUpParams } from '@/types/api/user'
import { FormContainer } from '@/components/atoms/form/FormContainer'
import { FormMain } from '@/components/atoms/form/FormMain'
import { FormTitle } from '@/components/atoms/form/FormTitle'
import { SubmitHandler, useForm } from 'react-hook-form'
import { EmailInput } from '@/components/molecules/user/EmailInput'
import { PasswordInput } from '@/components/molecules/user/PasswordInput'
import { UserNameInput } from '@/components/molecules/user/UserNameInput'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'

export const SignUp: FC = memo(() => {
  const { signUp, loading } = useAuth()

  const {
    register,
    handleSubmit,
    formState: { dirtyFields, errors },
  } = useForm<SignUpParams>({ criteriaMode: 'all' })

  const onSubmit: SubmitHandler<SignUpParams> = (params) => signUp(params)

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "サインアップ") %>
    // TODO react-hook-formを導入してスッキリさせる, バリデーションを追加する
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
            <FormInputWrap>
              <select id="area" className="input-field" {...register('prefectureCode')}>
                <option value="" selected hidden disabled>
                  エリアを選択してください
                </option>
                {PrefectureArray.map((prefecture: Prefecture) => (
                  <option value={prefecture.id}>{prefecture.label}</option>
                ))}
              </select>
              <FormIconWrap>
                <svg className="h-7 w-7 p-1 ml-3">
                  <use xlinkHref="#location-marker"></use>
                </svg>
              </FormIconWrap>
              <i className="fa-solid fa-angle-down pointer-events-none absolute inset-y-0 right-2 flex items-center px-2 text-gray-600"></i>
            </FormInputWrap>

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

            <div className="form-button-field mt-4">
              <PrimaryButton
                disabled={
                  !dirtyFields.name ||
                  !dirtyFields.email ||
                  !dirtyFields.prefectureCode ||
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
