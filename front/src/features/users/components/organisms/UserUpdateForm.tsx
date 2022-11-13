import type { ChangeEvent, Dispatch, FC, SetStateAction } from 'react'
import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { AxiosError } from 'axios'
import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/Elements/Button'
import { ImagePreview } from '@/components/Form'
import { useAuth } from '@/features/auth'
import { updateUser } from '@/features/users/api/updateUser'
import { EmailInput } from '@/features/users/components/molecules/EmailInput'
import { PrefectureSelect } from '@/features/users/components/molecules/PrefectureSelect'
import { UserDescribeInput } from '@/features/users/components/molecules/UserDescribeInput'
import { UserImageInput } from '@/features/users/components/molecules/UserImageInput'
import { UserNameInput } from '@/features/users/components/molecules/UserNameInput'
import type { User, UserUpdateParams } from '@/features/users/types'
import { useMessage } from '@/hooks/useMessage'
import type { PrefectureOption } from '@/utils/prefecture'
import { prefectureOptions } from '@/utils/prefecture'

import type { SubmitHandler, FieldError } from 'react-hook-form'

type Props = {
  user: User
  setIsError: Dispatch<SetStateAction<boolean>>
}

// react-hook-formで取り扱うデータの型
type UserUpdateDate = UserUpdateParams & {
  prefectureOption: PrefectureOption
}

export const UserUpdateForm: FC<Props> = (props) => {
  const { user, setIsError } = props
  const { authHeaders, loadUser } = useAuth()
  const navigate = useNavigate()
  const { showMessage } = useMessage()

  const userPrefectureCodeIndex = parseInt(user.prefectureCode, 10) - 1 // id -> 配列のindex合わせるため-1を行う

  const [loading, setLoading] = useState(false)
  const [previewImage, setPreviewImage] = useState<Array<string>>()

  const {
    register,
    handleSubmit,
    formState: { isDirty, errors },
    control,
  } = useForm<UserUpdateDate>({
    criteriaMode: 'all',
    defaultValues: {
      name: user.name,
      email: user.email,
      prefectureOption: prefectureOptions[userPrefectureCodeIndex],
      describe: user.describe,
    },
  })

  // TODO メールアドレスを変更すると認証情報が変わるため、再ログインが必要になる
  const onSubmit: SubmitHandler<UserUpdateDate> = useCallback(async (data) => {
    const createFormData = () => {
      const formData = new FormData()
      // 画像が選択されていない場合は更新しない
      if (data.image[0]) {
        formData.append('image', data.image[0])
      }
      formData.append('name', data.name)
      formData.append('email', data.email)
      formData.append('prefecture_code', data.prefectureOption.value.toString())
      if (data.describe) {
        formData.append('describe', data.describe)
      }
      return formData
    }

    const formData = createFormData()

    if (user.guest) {
      showMessage({ message: 'ゲストユーザーの編集はできません', type: 'error' })
      return
    }

    try {
      setLoading(true)
      await updateUser({ headers: authHeaders, formData })
      setIsError(false)
    } catch (error) {
      if (error instanceof AxiosError) {
        setIsError(true)
      }
      return
    } finally {
      setLoading(false)
    }

    loadUser()
    showMessage({ message: 'ユーザー情報を変更しました', type: 'success' })
    navigate('/users/home')
  }, [])

  const handleChangeImage = (e: ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      setPreviewImage([URL.createObjectURL(e.target.files[0])])
    }
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* プレビューフィールド */}
      {previewImage && <ImagePreview images={previewImage} />}

      {/* ファイル */}
      <UserImageInput label="image" register={register} error={errors.image} onChange={handleChangeImage} />

      {/* 名前 */}
      <UserNameInput label="name" register={register} error={errors.name} />

      {/* メールアドレス */}
      <EmailInput label="email" register={register} error={errors.email} />

      {/* エリアセレクト */}
      <PrefectureSelect label="prefectureOption" control={control} error={errors.prefectureOption as FieldError} />

      {/* 詳細 */}
      <UserDescribeInput label="describe" register={register} error={errors.describe} />

      <div className="flex items-center justify-center mt-4">
        <PrimaryButton disabled={!isDirty} loading={loading}>
          更新
        </PrimaryButton>
      </div>
    </form>
  )
}