import type { FC } from 'react'
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/Elements/Button'
import { NotificationMessage } from '@/components/Elements/Notification'
import { FormContainer, FormMain, FormTitle } from '@/components/Form'
import { resetPassword } from '@/features/auth/api/resetPassword'
import type { PasswordResetHeaders, PasswordResetParams } from '@/features/auth/types'
import { PasswordInput } from '@/features/users'
import { PasswordConfirmationInput } from '@/features/users/components/molecules/PasswordConfirmationInput'
import { useMessage } from '@/hooks/useMessage'
import { useNotification } from '@/hooks/useNotification'
import type { ErrorResponse } from '@/types'

import type { AxiosError } from 'axios'
import type { SubmitHandler } from 'react-hook-form'

type Props = PasswordResetHeaders

export const PasswordResetForm: FC<Props> = (props) => {
  const { uid, client, accessToken, resetPasswordToken } = props
  const navigate = useNavigate()
  const { showMessage } = useMessage()
  const { notifications, setNotifications, setNotificationMessagesWithType } = useNotification()

  const [isError, setIsError] = useState(false)
  const [loading, setLoading] = useState(false)

  const {
    register,
    watch,
    handleSubmit,
    formState: { isDirty, errors },
  } = useForm<PasswordResetParams>({ criteriaMode: 'all' })

  const onSubmitResetPassword: SubmitHandler<PasswordResetParams> = (data) => {
    const headers = {
      uid,
      client,
      resetPasswordToken,
      accessToken,
    }

    setLoading(true)
    resetPassword({ headers, params: data })
      .then(() => {
        setIsError(false)
        navigate('/auth/signin')
        showMessage({ message: 'パスワードの変更が完了しました', type: 'success' })
      })
      .catch((err: AxiosError<ErrorResponse>) => {
        const errorMessages = err.response?.data.errors.fullMessages
        const notificationMessages = errorMessages
          ? setNotificationMessagesWithType({ messages: errorMessages, type: 'error' })
          : null
        setNotifications(notificationMessages)
        setIsError(true)
      })
      .finally(() => {
        setLoading(false)
      })
  }

  return (
    <FormContainer>
      <FormMain>
        <FormTitle>パスワード再設定</FormTitle>
        {isError ? <NotificationMessage notifications={notifications} type="error" /> : null}

        <p className="text-center text-xs text-gray-800">新しいパスワードを入力してください</p>
        <form onSubmit={handleSubmit(onSubmitResetPassword)}>
          {/* パスワード */}
          <PasswordInput label="password" register={register} error={errors.password} />

          {/* パスワード確認 */}
          <PasswordConfirmationInput
            label="passwordConfirmation"
            targetValue={watch('password')}
            register={register}
            error={errors.passwordConfirmation}
          />
          <div className="flex items-center justify-center mt-4">
            <PrimaryButton loading={loading} disabled={!isDirty}>
              変更
            </PrimaryButton>
          </div>
        </form>
      </FormMain>
    </FormContainer>
  )
}
