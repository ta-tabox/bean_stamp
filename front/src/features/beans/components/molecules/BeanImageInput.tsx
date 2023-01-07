import type { ChangeEventHandler, FC } from 'react'

import { AlertMessage, FileInput, FormIconWrap, FormInputWrap } from '@/components/Form'
import { validation } from '@/utils/validation'

import type { FieldError, UseFormRegister } from 'react-hook-form'

type InputProps = {
  label: string
  register: UseFormRegister<any> // eslint-disable-line @typescript-eslint/no-explicit-any
  error?: FieldError
  onChange?: ChangeEventHandler<HTMLInputElement>
}

export const BeanImageInput: FC<InputProps> = (props) => {
  const { label, register, error, onChange } = props
  return (
    <>
      <FormInputWrap>
        <FileInput label={label} multiple register={register} onChange={onChange} required={validation.required} />
        <FormIconWrap>
          <i className="fa-solid fa-image fa-lg ml-3 p-1" />
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
      {/* 画像のonChangeにてsetErrorを実行 */}
      {error?.types?.validate && <AlertMessage>{error.types.validate}</AlertMessage>}
      {error?.types?.maxLength && <AlertMessage>{error.types.maxLength}</AlertMessage>}
    </>
  )
}