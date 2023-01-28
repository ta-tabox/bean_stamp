import type { Bean } from '@/features/beans'
import type { Roaster } from '@/features/roasters'

export type Offer = {
  id: number
  beanId: number
  price: number
  weight: number
  amount: number
  endedAt: string
  roastedAt: string
  receiptStartedAt: string
  receiptEndedAt: string
  status: OfferStatus
  createdAt: string
  wantCount: number
  roaster: Pick<Roaster, 'id' | 'name' | 'thumbnailUrl'>
  bean: Bean
}

export type OfferStatus = 'on_offering' | 'on_roasting' | 'on_preparing' | 'on_selling' | 'end_of_sales'

export type OfferCreateUpdateData = Pick<
  Offer,
  'beanId' | 'price' | 'weight' | 'amount' | 'endedAt' | 'roastedAt' | 'receiptStartedAt' | 'receiptEndedAt'
>
