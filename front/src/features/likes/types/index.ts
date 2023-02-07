import type { Offer } from '@/features/offers'

export type Want = {
  id: number
  userId: number
  offerId: number
  offer: Offer
}

export type WantRate = 'unrated' | 'bad' | 'so_so' | 'good' | 'excellent'
