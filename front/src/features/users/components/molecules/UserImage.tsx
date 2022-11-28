import type { FC } from 'react'

import defaultUserImage from '@/features/users/assets/default_user.png'
import type { User } from '@/features/users/types'

type Props = {
  user: User
}

export const UserImage: FC<Props> = (props) => {
  const { user } = props

  const imageUrl = user.image.url ? `${user.image.url}` : defaultUserImage

  return (
    <img
      src={imageUrl}
      alt={`${user.name}の画像`}
      className="object-cover object-center w-full h-48 lg:h-64 rounded-md shadow"
    />
  )
}
