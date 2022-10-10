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
import { Controller, SubmitHandler, useForm } from 'react-hook-form'
import { EmailInput } from '@/components/molecules/user/EmailInput'
import { PasswordInput } from '@/components/molecules/user/PasswordInput'
import { UserNameInput } from '@/components/molecules/user/UserNameInput'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'
import Select from 'react-select'
import { AlertMessage } from '@/components/atoms/form/AlertMessage'

// Selectメニューのprefectureオプションの型
type PrefectureOption = {
  label: string
  value: number
}

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

  // PrefectureArrayからreact-selectで取り扱うoptionの形に変換
  const convertToOption = (prefecture: Prefecture): PrefectureOption => {
    return {
      label: prefecture.label,
      value: prefecture.id,
    }
  }

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
            <FormInputWrap>
              {/* react-selectをreact-hook-form管理下で使用 */}
              <Controller
                name="prefectureOption"
                control={control}
                rules={{ required: `入力が必須の項目です'` }}
                render={({ field }) => (
                  <Select
                    {...field}
                    options={PrefectureArray.map(convertToOption)}
                    isClearable={true}
                    styles={{ control: () => ({}), valueContainer: (provided) => ({ ...provided, padding: 0 }) }} // デフォルトのスタイルをクリア
                    className="rs-container" // react-selectコンポーネントのクラス名
                    classNamePrefix="rs" // react-selectコンポーネント化のクラスに"rs__"プリフィックスをつける
                    noOptionsMessage={() => 'エリアが見つかりませんでした'}
                    placeholder="エリアを選択"
                  />
                )}
              />
              <FormIconWrap>
                <svg className="h-7 w-7 p-1 ml-3">
                  <use xlinkHref="#location-marker"></use>
                </svg>
              </FormIconWrap>
            </FormInputWrap>
            {errors.prefectureOption?.message && <AlertMessage>{errors.prefectureOption?.message}</AlertMessage>}

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
