import type { FC } from 'react'

import { AlertMessage, DateInput, FormInputWrap, Label } from '@/components/Form'
import { validation } from '@/utils/validation'

import type { FieldError, UseFormRegister } from 'react-hook-form'

type InputProps = {
  label: string
  register: UseFormRegister<any> // eslint-disable-line @typescript-eslint/no-explicit-any
  error?: FieldError
}

export const OfferEndedAtInput: FC<InputProps> = (props) => {
  const { label, register, error } = props
  return (
    <>
      <FormInputWrap>
        <Label label="オファー終了日">
          <DateInput label={label} register={register} required={validation.required} />
        </Label>
      </FormInputWrap>
      {error?.types?.required && <AlertMessage>{error.types.required}</AlertMessage>}
    </>
  )
}
