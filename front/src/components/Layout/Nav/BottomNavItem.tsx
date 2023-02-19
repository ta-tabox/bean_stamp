import type { FC, ReactNode } from 'react'

type Props = {
  children: ReactNode
}
export const BottomNavItem: FC<Props> = (props) => {
  const { children } = props
  return <div className="text-gray-500 hover:text-gray-800 transition duration-200 cursor-pointer">{children}</div>
}
