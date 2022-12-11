import type { FC } from 'react'
import { useCallback, useState, memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { AxiosError } from 'axios'
import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/Elements/Button'
import { NotificationMessage } from '@/components/Elements/Notification'
import { FormContainer, FormFooter, FormMain, FormTitle } from '@/components/Form'
import { Head } from '@/components/Head'
import { useAuth, useLoadUser, useSignedInUser } from '@/features/auth'
import { createRoaster } from '@/features/roasters/api/createRoaster'
import { RoasterAddressInput } from '@/features/roasters/components/molecules/RoasterAddressInput'
import { RoasterNameInput } from '@/features/roasters/components/molecules/RoasterNameInput'
import { RoasterPhoneNumberInput } from '@/features/roasters/components/molecules/RoasterPhoneNumberInput'
import { RoasterDescribeInput } from '@/features/roasters/components/molecules/RosterDescribeInput'
import { useCurrentRoaster } from '@/features/roasters/hooks/useCurrentRoaster'
import type { RoasterCreateParams } from '@/features/roasters/types'
import { PrefectureSelect } from '@/features/users'
import { useErrorNotification } from '@/hooks/useErrorNotification'
import { useMessage } from '@/hooks/useMessage'
import { useNotification } from '@/hooks/useNotification'
import type { ApplicationErrorResponse } from '@/types'
import type { PrefectureOption } from '@/utils/prefecture'

import type { FieldError, SubmitHandler } from 'react-hook-form'

// react-hook-formで取り扱うデータの型
type RoasterCreateData = RoasterCreateParams & {
  prefectureOption: PrefectureOption
}

export const RoasterNew: FC = memo(() => {
  const { notifications } = useNotification()
  const { setErrorNotifications } = useErrorNotification()
  const { showMessage } = useMessage()
  const navigate = useNavigate()
  const { authHeaders } = useAuth()
  const { loadUser } = useLoadUser()
  const { setIsBelongingToRoaster } = useSignedInUser()
  const { setIsRoaster, setCurrentRoaster } = useCurrentRoaster()

  const [isError, setIsError] = useState(false)
  const [loading, setLoading] = useState(false)

  const {
    register,
    watch,
    handleSubmit,
    formState: { dirtyFields, errors },
    control,
  } = useForm<RoasterCreateData>({ criteriaMode: 'all' })

  const onSubmit: SubmitHandler<RoasterCreateData> = useCallback(async (data) => {
    // PUTリクエスト用のフォームを作成する
    // FormDataじゃなくて普通にparamsとして送れないか？
    const createFormData = () => {
      const formData = new FormData()
      // 画像が選択されていない場合は更新しない
      // if (data.image[0]) {
      //   formData.append('image', data.image[0])
      // }
      formData.append('roaster[name]', data.name)
      formData.append('roaster[phone_number]', data.phoneNumber)
      formData.append('roaster[prefecture_code]', data.prefectureOption.value.toString())
      formData.append('roaster[address]', data.address)
      if (data.describe) {
        formData.append('roaster[describe]', data.describe)
      }
      return formData
    }

    const formData = createFormData()

    try {
      setLoading(true)
      await createRoaster({ headers: authHeaders, formData })
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
    showMessage({ message: 'ロースターを作成しました', type: 'success' })
    navigate('/roasters/home')
  }, [])

  return (
    <>
      <Head title="ロースター登録" />
      <div className="mt-16 flex items-center">
        <FormContainer>
          <FormMain>
            <FormTitle>ロースター登録</FormTitle>
            {isError ? <NotificationMessage notifications={notifications} type="error" /> : null}
            <form onSubmit={handleSubmit(onSubmit)}>
              {/* 店舗名 */}
              <RoasterNameInput label="name" register={register} error={errors.name} />

              {/* 電話番号 */}
              <RoasterPhoneNumberInput label="phoneNumber" register={register} error={errors.phoneNumber} />

              {/* 都道府県 */}
              <PrefectureSelect
                label="prefectureOption"
                control={control}
                error={errors.prefectureOption as FieldError}
              />
              {/* 住所 */}
              <RoasterAddressInput label="address" register={register} error={errors.address} />

              {/* 店舗紹介 */}
              <RoasterDescribeInput label="describe" register={register} error={errors.describe} />

              <div className="flex items-center justify-center mt-4">
                <PrimaryButton
                  disabled={
                    !dirtyFields.name ||
                    !dirtyFields.phoneNumber ||
                    !dirtyFields.prefectureOption ||
                    !dirtyFields.address ||
                    !dirtyFields.describe
                  }
                  loading={loading}
                >
                  登録
                </PrimaryButton>
              </div>
            </form>
          </FormMain>

          <FormFooter>
            <div>Footer</div>
          </FormFooter>
        </FormContainer>
      </div>
    </>
  )
})
