import type { FC } from 'react'

import defaultRoasterImage from '@/features/roasters/assets/defaultRoaster.png'
import type { Roaster } from '@/features/roasters/types'

type Props = {
  roaster: Roaster
}

export const RoasterThumbnail: FC<Props> = (props) => {
  const { roaster } = props

  const imageUrl = roaster.image.thumb.url ? `${roaster.image.thumb.url}` : defaultRoasterImage

  return (
    <img
      className="object-cover w-20 h-20 border-2 border-indigo-500 rounded-full"
      src={`${imageUrl}`}
      alt={`${roaster.name}の画像`}
    />
  )
}
