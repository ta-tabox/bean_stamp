import type { FC } from 'react'

import { FormIconWrap, FormInputWrap, Input } from '@/components/Form'

import type { UseFormRegister } from 'react-hook-form'

type InputProps = {
  label: string
  register: UseFormRegister<any> // eslint-disable-line @typescript-eslint/no-explicit-any
}

export const BeanVarietyInput: FC<InputProps> = (props) => {
  const { label, register } = props
  return (
    <FormInputWrap>
      <Input label={label} type="text" placeholder="品種" register={register} />
      <FormIconWrap>
        <i className="fa-solid fa-leaf fa-lg" />
      </FormIconWrap>
    </FormInputWrap>
  )
}
