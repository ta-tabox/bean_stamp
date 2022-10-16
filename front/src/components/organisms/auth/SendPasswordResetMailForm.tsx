import type { FC } from 'react'
import { useState } from 'react'

import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { FormContainer } from '@/components/atoms/form/FormContainer'
import { FormMain } from '@/components/atoms/form/FormMain'
import { FormTitle } from '@/components/atoms/form/FormTitle'
import { EmailInput } from '@/components/molecules/user/EmailInput'
import { useMessage } from '@/hooks/useMessage'
import client from '@/lib/api/client'

import type { AxiosError } from 'axios'
import type { SubmitHandler } from 'react-hook-form'

// パスワード再設定関連の型
type SendResetMailType = {
  email: string
}

export const SendPasswordResetMailForm: FC = () => {
  const {
    register,
    handleSubmit,
    formState: { isDirty, errors },
  } = useForm<SendResetMailType>({ criteriaMode: 'all' })

  const { showMessage } = useMessage()
  const [isSubmitted, setIsSubmitted] = useState(false)

  const onSendResetMail: SubmitHandler<SendResetMailType> = (data) => {
    const redirectUrl = `${import.meta.env.VITE_FRONT_URL}/password_reset`
    const params = {
      email: data.email,
      redirect_url: redirectUrl,
    }
    client
      .post('auth/password', params)
      .then(() => {
        setIsSubmitted(true)
        showMessage({ message: 'パスワードの再設定を受け付けました', type: 'success' })
      })
      .catch((err: AxiosError<{ errors: Array<string> }>) => {
        const errorMessages = err.response?.data.errors
        errorMessages?.map((errorMessage) => showMessage({ message: `${errorMessage}`, type: 'error' }))
      })
  }
  return (
    <FormContainer>
      <FormMain>
        <FormTitle>パスワード再設定</FormTitle>
        <div className="text-center text-xs text-gray-800">
          {isSubmitted ? (
            <p>
              パスワードの再設定について数分以内にメールでご連絡いたします
              <br />
              メールからパスワードの再設定を行ってください
            </p>
          ) : (
            <p>
              パスワードを再設定するには
              <br />
              登録したメールアドレスを入力してください
            </p>
          )}
        </div>

        <form onSubmit={handleSubmit(onSendResetMail)}>
          {/* メールアドレス */}
          <EmailInput label="email" register={register} error={errors.email} disabled={isSubmitted} />
          <div className="flex items-center justify-center mt-4">
            <PrimaryButton loading={undefined} disabled={!isDirty || isSubmitted}>
              メールを送信
            </PrimaryButton>
          </div>
        </form>
      </FormMain>
    </FormContainer>
  )
}
