import type { FC } from 'react'
import { useCallback, useState, memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { AxiosError } from 'axios'

import { NotificationMessage } from '@/components/Elements/Notification'
import { FormContainer, FormMain, FormTitle } from '@/components/Form'
import { Head } from '@/components/Head'
import { useLoadUser } from '@/features/auth'
import { createBean } from '@/features/beans/api/createBean'
import { BeanForm } from '@/features/beans/components/organisms/BeanForm'
import type { BeanCreateUpdateData } from '@/features/beans/types'
import { createBeanFormData } from '@/features/beans/utils/createBeanFormData'
import { useCurrentRoaster } from '@/features/roasters/hooks/useCurrentRoaster'
import { useErrorNotification } from '@/hooks/useErrorNotification'
import { useMessage } from '@/hooks/useMessage'
import type { ApplicationErrorResponse } from '@/types'

import type { SubmitHandler } from 'react-hook-form'

export const BeanNew: FC = memo(() => {
  const { setErrorNotifications, errorNotifications } = useErrorNotification()
  const { showMessage } = useMessage()
  const navigate = useNavigate()
  const { loadUser } = useLoadUser()

  const { setIsRoaster } = useCurrentRoaster()

  const [isError, setIsError] = useState(false)
  const [loading, setLoading] = useState(false)

  const onSubmit: SubmitHandler<BeanCreateUpdateData> = useCallback(async (data) => {
    const formData = createBeanFormData(data)
    console.log(data)

    try {
      setLoading(true)
      await createBean({ formData })
      setIsError(false)
    } catch (error) {
      if (error instanceof AxiosError) {
        // NOTE errorの型指定 他に良い方法はないのか？
        const typedError = error as AxiosError<ApplicationErrorResponse>
        const errorMessages = typedError.response?.data.messages
        if (errorMessages) {
          setErrorNotifications(errorMessages)
          setIsError(true)
        }
      }
      return
    } finally {
      setLoading(false)
    }

    await loadUser()

    setIsRoaster(true)
    showMessage({ message: 'コーヒー豆を作成しました', type: 'success' })
    navigate('/beans')
  }, [])

  return (
    <>
      <Head title="コーヒー豆登録" />
      <div className="mt-16 flex items-center">
        <FormContainer>
          <FormMain>
            <FormTitle>コーヒー豆登録</FormTitle>
            {isError ? <NotificationMessage notifications={errorNotifications} type="error" /> : null}
            <BeanForm submitTitle="登録" loading={loading} onSubmit={onSubmit} />
          </FormMain>
        </FormContainer>
      </div>
    </>
  )
})
