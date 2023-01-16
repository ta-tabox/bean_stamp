import type { FC } from 'react'

import defaultUserImage from '@/features/users/assets/defaultUser.png'
import type { User } from '@/features/users/types'

type Props = {
  user: User
}

export const UserThumbnail: FC<Props> = (props) => {
  const { user } = props

  const imageUrl = user.thumbUrl ? `${user.thumbUrl}` : defaultUserImage

  return (
    <img
      className="object-cover w-20 h-20 border-2 border-indigo-500 rounded-full"
      src={`${imageUrl}`}
      alt={`${user.name}の画像`}
    />
  )
}
