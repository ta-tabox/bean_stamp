import type { FC } from 'react'
import { Link } from 'react-router-dom'

type Props = {
  id: number
  name: string
}

export const RoasterNameLink: FC<Props> = (props) => {
  const { id, name } = props
  return (
    <div className="w-2/3 md:w-1/3 ml-auto text-right text-base text-gray-500 tracking-widest hover:text-gray-800 truncate">
      <Link to={`/roasters/${id}`}>{name}</Link>
    </div>
  )
}
