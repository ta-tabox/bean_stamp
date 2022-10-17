import type { FC, ReactNode } from 'react'

type Props = {
  children: ReactNode
}

export const FormContainer: FC<Props> = (props) => {
  const { children } = props
  return <div className="p-8 max-w-xl mx-auto container">{children}</div>
}
