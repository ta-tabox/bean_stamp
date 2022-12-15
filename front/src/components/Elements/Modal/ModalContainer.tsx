import type { FC, ReactNode } from 'react'

type Props = {
  children: ReactNode
}

export const ModalContainer: FC<Props> = (props) => {
  const { children } = props
  return <div className="px-4 sm:px-8">{children}</div>
}
