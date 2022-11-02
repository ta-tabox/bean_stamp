import type { FC, ReactNode } from 'react'
import { Link } from 'react-router-dom'

type Props = {
  children: ReactNode
  title: string
  to: string
}
export const SideNavLink: FC<Props> = (props) => {
  const { children, title, to } = props
  return (
    <Link to={to}>
      <div className="text-gray-500 hover:text-gray-800 transition duration-200 transform hover:-translate-x-4 group flex items-end">
        {children}
        <div className="font-notoserif italic text-gray-500 transition opacity-0 group-hover:opacity-100 ml-1">
          {title}
        </div>
      </div>
    </Link>
  )
}
