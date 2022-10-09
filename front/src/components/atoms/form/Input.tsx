import type { FC, ReactNode } from 'react'
import { UseFormRegister, ValidationRule } from 'react-hook-form'

type InputProps = {
  label: string
  type: React.HTMLInputTypeAttribute
  register: UseFormRegister<any>
  placeholder?: string
  required?: string | ValidationRule<boolean>
  pattern?: ValidationRule<RegExp>
  minLength?: ValidationRule<number>
}

export const Input: FC<InputProps> = (props) => {
  const { label, type, placeholder, register, required, pattern, minLength } = props
  return (
    <>
      <input
        type={type}
        placeholder={placeholder}
        className="appearance-none border pl-12 border-gray-100 shadow-sm focus:shadow-md focus:placeholder-gray-600 transition rounded-md w-full py-3 text-gray-600 leading-tight focus:outline-none"
        {...register(label, { required, pattern, minLength })}
      />
    </>
  )
}
