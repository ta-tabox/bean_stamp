import type { FC } from 'react'
import { useEffect } from 'react'

import { Controller } from 'react-hook-form'
import Select from 'react-select'

import { AlertMessage, FormIconWrap, FormInputWrap } from '@/components/Form'
import type { BeanCreateUpdateData } from '@/features/beans/types'
import { tasteTagOptions } from '@/features/beans/utils/tasteTag'
import { validation } from '@/utils/validation'

import type { Control, FieldError, UseFormWatch, UseFormSetError, UseFormClearErrors } from 'react-hook-form'

type InputProps = {
  label: string
  control: Control<any> // eslint-disable-line @typescript-eslint/no-explicit-any
  watch: UseFormWatch<BeanCreateUpdateData>
  setError: UseFormSetError<BeanCreateUpdateData>
  clearErrors: UseFormClearErrors<BeanCreateUpdateData>
  error?: FieldError
}

export const BeanTasteTagSelectInput: FC<InputProps> = (props) => {
  const { label, control, watch, setError, clearErrors, error } = props

  const maxTasteTagNum = 3
  const minTasteTagNum = 2

  useEffect(() => {
    clearErrors('tasteTagOptions')
    const tasteTags = watch('tasteTagOptions')

    if (!tasteTags) {
      return
    }
    if (tasteTags.length < minTasteTagNum) {
      setError('tasteTagOptions', {
        types: {
          minLength: `フレーバーは${minTasteTagNum}個以上登録してください`,
        },
      })
    }
    if (tasteTags.length > maxTasteTagNum) {
      setError('tasteTagOptions', {
        types: {
          maxLength: `フレーバーは最大${maxTasteTagNum}個まで登録できます`,
        },
      })
    }
  }, [watch('tasteTagOptions')])

  return (
    <>
      <FormInputWrap>
        {/* react-selectをreact-hook-form管理下で使用 */}
        <Controller
          name={label}
          control={control}
          rules={{ required: validation.required, maxLength: 3, minLength: 2 }}
          render={({ field }) => (
            <Select
              {...field}
              options={tasteTagOptions}
              isClearable
              isMulti
              styles={{ control: () => ({}), valueContainer: (provided) => ({ ...provided, padding: 0 }) }} // デフォルトのスタイルをクリア
              className="rs-container" // react-selectコンポーネントのクラス名
              classNamePrefix="rs" // react-selectコンポーネント化のクラスに"rs__"プリフィックスをつける
              noOptionsMessage={() => 'フレーバーが見つかりませんでした'}
              placeholder="フレーバーを選択"
            />
          )}
        />
        <FormIconWrap>
          {/* TODO アイコンを変える */}
          <i className="fa-solid fa-earth-asia fa-lg ml-3 p-1" />
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
      {error?.types?.maxLength && <AlertMessage>{error.types.maxLength}</AlertMessage>}
      {error?.types?.minLength && <AlertMessage>{error.types.minLength}</AlertMessage>}
    </>
  )
}
