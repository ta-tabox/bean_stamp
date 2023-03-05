import type { FC } from 'react'
import { Link } from 'react-router-dom'

type Props = {
  title: string
  to: string
}
export const DrawerNavLink: FC<Props> = (props) => {
  const { title, to } = props
  return (
    <Link to={to}>
      <div className="block w-full h-full pl-8 py-4 text-lg text-gray-600 border-y border-gray-100 hover:text-gray-800 hover:bg-gray-200">
        {title}
      </div>
    </Link>
  )
}
