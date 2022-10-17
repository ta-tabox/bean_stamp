import type { FC } from 'react'
import { useNavigate } from 'react-router-dom'

import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/Elements/Button'
import { FormContainer, FormMain, FormTitle } from '@/components/Form'
import { PasswordInput } from '@/features/users'
import { useMessage } from '@/hooks/useMessage'
import client from '@/lib/client'

import type { AxiosError } from 'axios'
import type { SubmitHandler } from 'react-hook-form'

// パスワード再設定関連の型
type PasswordResetType = {
  password: string
  passwordConfirmation: string
}

type Props = {
  uid: string
  uClient: string
  accessToken: string
  resetPasswordToken: string
}

export const PasswordResetForm: FC<Props> = (props) => {
  const { uid, uClient, accessToken, resetPasswordToken } = props
  const navigate = useNavigate()

  const {
    register,
    handleSubmit,
    formState: { isDirty, errors },
  } = useForm<PasswordResetType>({ criteriaMode: 'all' })

  const { showMessage } = useMessage()

  const onSubmitResetPassword: SubmitHandler<PasswordResetType> = (data) => {
    client
      .put('auth/password', data, {
        headers: {
          uid,
          client: uClient,
          'access-token': accessToken,
          reset_password_token: resetPasswordToken,
        },
      })
      .then(() => {
        navigate('/auth/signin')
        showMessage({ message: 'パスワードの変更が完了しました', type: 'success' })
      })
      .catch((err: AxiosError<{ errors: { fullMessages: Array<string> } }>) => {
        const errorMessages = err.response?.data.errors.fullMessages
        errorMessages?.map((errorMessage) => showMessage({ message: `${errorMessage}`, type: 'error' }))
      })
  }

  return (
    <FormContainer>
      <FormMain>
        <FormTitle>パスワード再設定</FormTitle>
        <p className="text-center text-xs text-gray-800">新しいパスワードを入力してください</p>
        <form onSubmit={handleSubmit(onSubmitResetPassword)}>
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
            <PrimaryButton loading={undefined} disabled={!isDirty}>
              変更
            </PrimaryButton>
          </div>
        </form>
      </FormMain>
    </FormContainer>
  )
}
