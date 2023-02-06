import type { Offer } from '@/features/offers'

type Options = {
  offer: Offer
}

export const isAfterReceiptStartedAt = ({ offer }: Options) => {
  const now = new Date()
  const receiptStartedAt = new Date(offer.receiptStartedAt)
  return now >= receiptStartedAt
}
