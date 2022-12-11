import type { FC } from 'react'

import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/Elements/Button'
import { RoasterAddressInput } from '@/features/roasters/components/molecules/RoasterAddressInput'
import { RoasterNameInput } from '@/features/roasters/components/molecules/RoasterNameInput'
import { RoasterPhoneNumberInput } from '@/features/roasters/components/molecules/RoasterPhoneNumberInput'
import { RoasterDescribeInput } from '@/features/roasters/components/molecules/RosterDescribeInput'
import type { RoasterCreateData } from '@/features/roasters/types'
import { PrefectureSelect } from '@/features/users'

import type { FieldError, SubmitHandler } from 'react-hook-form'

type Props = {
  loading: boolean
  submitTitle: string
  onSubmit: SubmitHandler<RoasterCreateData>
}

export const RoasterForm: FC<Props> = (props) => {
  const { loading, submitTitle, onSubmit } = props

  const {
    register,
    handleSubmit,
    formState: { dirtyFields, errors },
    control,
  } = useForm<RoasterCreateData>({ criteriaMode: 'all' })

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* 店舗名 */}
      <RoasterNameInput label="name" register={register} error={errors.name} />

      {/* 電話番号 */}
      <RoasterPhoneNumberInput label="phoneNumber" register={register} error={errors.phoneNumber} />

      {/* 都道府県 */}
      <PrefectureSelect label="prefectureOption" control={control} error={errors.prefectureOption as FieldError} />
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
          {submitTitle}
        </PrimaryButton>
      </div>
    </form>
  )
}
