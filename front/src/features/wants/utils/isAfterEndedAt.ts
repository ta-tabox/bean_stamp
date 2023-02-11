import type { Offer } from '@/features/offers'

type Options = {
  offer: Offer
}

export const isAfterEndedAt = ({ offer }: Options) => {
  const now = new Date()
  const rowDate = new Date(offer.endedAt)
  const [year, month, date] = [rowDate.getFullYear(), rowDate.getMonth(), rowDate.getDate()]
  const endedAt = new Date(year, month, date)

  return now > endedAt
}
