import type { FC } from 'react'

import type { Offer } from '@/features/offers/types'

type Props = {
  offer: Offer
}
export const RecommendedOfferItem: FC<Props> = (props) => {
  const { offer } = props
  return <div>{offer.bean.name}</div>
}
