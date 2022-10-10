import { AlertMessage } from '@/components/atoms/form/AlertMessage'
import { Input } from '@/components/atoms/form/Input'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import type { FC } from 'react'
import { FieldError, UseFormRegister } from 'react-hook-form'

type InputProps = {
  label: string
  register: UseFormRegister<any>
  error?: FieldError
}

export const UserNameInput: FC<InputProps> = (props) => {
  const { label, register, error } = props
  return (
    <>
      <FormInputWrap>
        <Input
          label={label}
          type="text"
          placeholder="名前"
          register={register}
          required={{
            value: true,
            message: '入力が必須の項目です',
          }}
        />
        <FormIconWrap>
          <svg className="h-7 w-7 p-1 ml-3">
            <use xlinkHref="#academic-cap"></use>
          </svg>
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
    </>
  )
}
