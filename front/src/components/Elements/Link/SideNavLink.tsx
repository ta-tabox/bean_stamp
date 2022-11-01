import type { FC, ReactNode } from 'react'

type Props = {
  children: ReactNode
  title: string
}
export const SideNavLink: FC<Props> = (props) => {
  const { children, title } = props
  return (
    // TODO Linkまで入れる
    <div className="text-gray-500 hover:text-gray-800 transition duration-200 transform hover:-translate-x-4 group flex items-end">
      {children}
      <div className="font-notoserif italic text-gray-500 transition opacity-0 group-hover:opacity-100 ml-1">
        {title}
      </div>
    </div>
  )
}
