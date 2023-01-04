import type { FC } from 'react'
import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { Link } from '@/components/Elements/Link'
import { NotificationMessage } from '@/components/Elements/Notification'
import { Spinner } from '@/components/Elements/Spinner'
import { FormContainer, FormFooter, FormMain, FormTitle } from '@/components/Form'
import { Head } from '@/components/Head'
import { useLoadUser } from '@/features/auth'
import { BeanForm } from '@/features/beans/components/organisms/BeanForm'
import type { BeanApiType, BeanCreateUpdateData } from '@/features/beans/types'
import { useCurrentRoaster } from '@/features/roasters/hooks/useCurrentRoaster'
import { useErrorNotification } from '@/hooks/useErrorNotification'
import { useMessage } from '@/hooks/useMessage'

import type { SubmitHandler } from 'react-hook-form'

export const BeanEdit: FC = () => {
  const { setErrorNotifications, errorNotifications } = useErrorNotification()
  const { showMessage } = useMessage()
  const navigate = useNavigate()
  const { loadUser } = useLoadUser()

  const { setIsRoaster, currentRoaster } = useCurrentRoaster()

  const [isError, setIsError] = useState(false)
  const [loading, setLoading] = useState(false)

  const onSubmit: SubmitHandler<BeanCreateUpdateData> = useCallback((data) => {
    console.log(data)
    // if (currentRoaster === null) {
    //   showMessage({ message: 'ロースターを登録をしてください', type: 'error' })
    //   navigate('/roasters/create')
    //   return
    // }
    // const formData = createRoasterFormData(data)

    // try {
    //   setLoading(true)
    //   await updateRoaster({ id: currentRoaster.id.toString(), formData })
    //   setIsError(false)
    // } catch (error) {
    //   if (error instanceof AxiosError) {
    //     // NOTE errorの型指定 他に良い方法はないのか？
    //     const typedError = error as AxiosError<ApplicationErrorResponse>
    //     const errorMessages = typedError.response?.data.messages
    //     if (errorMessages) {
    //       setErrorNotifications(errorMessages)
    //       setIsError(true)
    //     }
    //   }
    //   return
    // } finally {
    //   setLoading(false)

    //   await loadUser()

    //   setIsRoaster(true)
    //   showMessage({ message: 'ロースター情報を変更しました', type: 'success' })
    //   navigate('/roasters/home')
    // }
  }, [])

  let bean: BeanApiType | undefined

  return (
    <>
      <Head title="コーヒー豆編集" />
      {!bean && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}
      {currentRoaster && (
        <div className="mt-20">
          <FormContainer>
            <FormMain>
              <FormTitle>コーヒー豆編集</FormTitle>
              {isError ? <NotificationMessage notifications={errorNotifications} type="error" /> : null}

              <BeanForm submitTitle="更新" loading={loading} onSubmit={onSubmit} bean={bean} />

              <FormFooter>
                {/* TODO destroyリクエストをモーダル表示から実行できるようにする */}
                <Link to="/beans/cancel">コーヒー豆を削除する</Link>
              </FormFooter>
            </FormMain>
          </FormContainer>
        </div>
      )}
    </>
  )
}
