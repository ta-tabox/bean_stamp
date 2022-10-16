import type { FC } from 'react'

import { Controller } from 'react-hook-form'
import Select from 'react-select'

import { AlertMessage } from '@/components/atoms/form/AlertMessage'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import type { Prefecture } from '@/utils/prefecture'
import { PrefectureArray } from '@/utils/prefecture'

import type { Control, FieldError } from 'react-hook-form'

type InputProps = {
  label: string
  control: Control<any> // eslint-disable-line @typescript-eslint/no-explicit-any
  error?: FieldError
}

// Selectメニューのprefectureオプションの型
export type PrefectureOption = {
  label: string
  value: number
}

export const PrefectureSelect: FC<InputProps> = (props) => {
  const { label, control, error } = props

  // PrefectureArrayからreact-selectで取り扱うoptionの形に変換
  const convertToOption = (prefecture: Prefecture): PrefectureOption => ({
    label: prefecture.label,
    value: prefecture.id,
  })

  return (
    <>
      <FormInputWrap>
        {/* react-selectをreact-hook-form管理下で使用 */}
        <Controller
          name={label}
          control={control}
          rules={{ required: `入力が必須の項目です'` }}
          render={({ field }) => (
            <Select
              {...field}
              options={PrefectureArray.map(convertToOption)}
              isClearable
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
            <use xlinkHref="#location-marker" />
          </svg>
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
    </>
  )
}
