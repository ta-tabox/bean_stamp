import type { FC } from 'react'

import { useForm } from 'react-hook-form'

import { PrimaryButton } from '@/components/Elements/Button'
import { RoasterAddressInput } from '@/features/roasters/components/molecules/RoasterAddressInput'
import { RoasterNameInput } from '@/features/roasters/components/molecules/RoasterNameInput'
import { RoasterPhoneNumberInput } from '@/features/roasters/components/molecules/RoasterPhoneNumberInput'
import { RoasterDescribeInput } from '@/features/roasters/components/molecules/RosterDescribeInput'
import type { Roaster, RoasterCreateData } from '@/features/roasters/types'
import { PrefectureSelect } from '@/features/users'
import { convertPrefectureCodeToIndex, prefectureOptions } from '@/utils/prefecture'

import type { FieldError, SubmitHandler } from 'react-hook-form'

type Props = {
  roaster?: Roaster | null
  loading: boolean
  submitTitle: string
  onSubmit: SubmitHandler<RoasterCreateData>
}

export const RoasterForm: FC<Props> = (props) => {
  const { roaster = null, loading, submitTitle, onSubmit } = props

  // フォーム初期値の設定 RoasterNew -> {}, RoasterEdit -> {初期値}
  const defaultValues = () => {
    let values = {}
    if (roaster) {
      // codeId -> 配列のindexへ変換
      const prefectureCodeIndex = convertPrefectureCodeToIndex(roaster.prefectureCode)
      values = {
        name: roaster.name,
        phoneNumber: roaster.phoneNumber,
        prefectureOption: prefectureOptions[prefectureCodeIndex],
        address: roaster.address,
        describe: roaster.describe,
      }
    }
    return values
  }

  const {
    register,
    handleSubmit,
    formState: { isDirty, dirtyFields, errors },
    control,
  } = useForm<RoasterCreateData>({
    criteriaMode: 'all',
    defaultValues: defaultValues(),
  })

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
        {/* roasterあり→ どれか変更, なし→ 該当項目変更必須 */}
        <PrimaryButton
          disabled={
            roaster
              ? !isDirty
              : !dirtyFields.name || !dirtyFields.phoneNumber || !dirtyFields.prefectureOption || !dirtyFields.address
          }
          loading={loading}
        >
          {submitTitle}
        </PrimaryButton>
      </div>
    </form>
  )
}
