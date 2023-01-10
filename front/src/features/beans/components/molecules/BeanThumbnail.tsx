import type { FC } from 'react'

import defaultBeanImage from '@/features/beans/assets/defaultBean.png'
import type { Bean } from '@/features/beans/types'

type Props = {
  bean: Bean
}

export const BeanThumbnail: FC<Props> = (props) => {
  const { bean } = props

  const imageUrl = bean.imageUrls.length ? `${bean.imageUrls[0]}` : defaultBeanImage

  return (
    <img
      className="object-cover w-20 h-20 border-2 border-indigo-500 rounded-full"
      src={`${imageUrl}`}
      alt={`${bean.name}の画像`}
    />
  )
}
