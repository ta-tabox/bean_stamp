import type { FC } from 'react'

import type { UseFormRegister, Validate, ValidationRule } from 'react-hook-form'

type InputProps = {
  label: string
  disabled?: boolean
  register: UseFormRegister<any> // eslint-disable-line @typescript-eslint/no-explicit-any
  placeholder?: string
  required?: string | ValidationRule<boolean>
  min?: ValidationRule<number>
  max?: ValidationRule<number>
  validate?: Validate<any> // eslint-disable-line @typescript-eslint/no-explicit-any
}

export const DateInput: FC<InputProps> = (props) => {
  const { label, disabled, placeholder, register, required, min, max, validate } = props
  return (
    <input
      id={label}
      type="date"
      disabled={disabled}
      placeholder={placeholder}
      className="appearance-none border pl-1 sm:pl-4 border-gray-100 shadow-sm focus:shadow-md focus:placeholder-gray-600 transition rounded-md w-full py-3 text-gray-600 leading-tight focus:outline-none"
      {...register(label, { required, min, max, validate })}
    />
  )
}
