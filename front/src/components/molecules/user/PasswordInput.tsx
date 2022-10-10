import { AlertMessage } from '@/components/atoms/form/AlertMessage'
import { Input } from '@/components/atoms/form/Input'
import { FormIconWrap } from '@/components/atoms/form/FormIconWrap'
import { FormInputWrap } from '@/components/atoms/form/FormInputWrap'
import type { FC } from 'react'
import { FieldError, UseFormRegister } from 'react-hook-form'

type InputProps = {
  label: string
  placeholder: string
  register: UseFormRegister<any>
  error?: FieldError
}

export const PasswordInput: FC<InputProps> = (props) => {
  const { label, placeholder, register, error } = props
  return (
    <>
      <FormInputWrap>
        <Input
          label={label}
          type="password"
          placeholder={placeholder}
          register={register}
          required={{
            value: true,
            message: '入力が必須の項目です',
          }}
          pattern={{ value: /^[a-zA-Z0-9!-/:-@¥[-`{-~]+$/, message: '半角英数記号を入力してください' }}
          minLength={{ value: 6, message: '6文字以上入力してください' }}
        />
        <FormIconWrap>
          <svg className="h-7 w-7 p-1 ml-3">
            <use xlinkHref="#unlock"></use>
          </svg>
        </FormIconWrap>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
      {error?.types?.minLength && <AlertMessage>{error.types.minLength}</AlertMessage>}
      {error?.types?.pattern && <AlertMessage>{error.types.pattern}</AlertMessage>}
    </>
  )
}
