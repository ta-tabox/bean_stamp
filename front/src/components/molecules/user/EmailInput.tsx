import type { FC } from 'react'

import { AlertMessage } from '@/components/atoms/form/AlertMessage'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import { Input } from '@/components/atoms/form/Input'

import type { FieldError, UseFormRegister } from 'react-hook-form'

type InputProps = {
  label: string
  register: UseFormRegister<any> // eslint-disable-line @typescript-eslint/no-explicit-any
  error?: FieldError
  disabled?: boolean
}

export const EmailInput: FC<InputProps> = (props) => {
  const { label, register, error, disabled } = props
  return (
    <>
      <FormInputWrap>
        <Input
          label={label}
          type="email"
          placeholder="メールアドレス"
          disabled={disabled}
          register={register}
          required={{
            value: true,
            message: '入力が必須の項目です',
          }}
          pattern={{
            value: /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]+.[A-Za-z0-9]+$/,
            message: 'メールアドレスの形式が正しくありません。',
          }}
        />
        <FormIconWrap>
          <svg className="h-7 w-7 p-1 ml-3">
            <use xlinkHref="#mail" />
          </svg>
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
      {error?.types?.pattern && <AlertMessage>{error.types.pattern}</AlertMessage>}
    </>
  )
}
