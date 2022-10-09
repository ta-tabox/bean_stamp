import { AlertMessage } from '@/components/atoms/form/AlertMessage'
import { Input } from '@/components/atoms/form/Input'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import type { FC, ReactNode } from 'react'
import { FieldError, UseFormRegister, ValidationRule } from 'react-hook-form'

type InputProps = {
  label: string
  register: UseFormRegister<any>
  error?: FieldError
}

export const EmailInput: FC<InputProps> = (props) => {
  const { label, register, error } = props
  return (
    <>
      <FormInputWrap>
        <Input
          label={label}
          type="email"
          placeholder="メールアドレス"
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
            <use xlinkHref="#mail"></use>
          </svg>
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error?.types?.required}</AlertMessage>}
      {error?.types?.pattern && <AlertMessage>{error?.types?.pattern}</AlertMessage>}
    </>
  )
}
