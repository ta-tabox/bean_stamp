import type { FC } from 'react'
import { useEffect } from 'react'
import { useLocation } from 'react-router-dom'

import { Copyright } from '@/components/Elements/Copyright'
import { SearchLink } from '@/components/Elements/Link'
import { useSignedInUser } from '@/features/auth'
import { useRandomSelectRecommendedOffers, RecommendedOfferItem, useGetRecommendedOffers } from '@/features/offers'

export const UserAsideContent: FC = () => {
  const location = useLocation()
  const { recommendedOffers, randomSelectRecommendedOffers } = useRandomSelectRecommendedOffers()

  const { getRecommendedOffers } = useGetRecommendedOffers()
  const { signedInUser } = useSignedInUser()

  useEffect(() => {
    if (signedInUser) {
      getRecommendedOffers()
    }
  }, [signedInUser])

  useEffect(() => {
    randomSelectRecommendedOffers()
  }, [location])

  return (
    <div id="user-aside" className="min-h-screen h-auto w-full flex flex-col items-center">
      <div className="w-full sticky top-0 bg-gray-50 z-50">
        <div className="w-44 mt-10 mx-auto">
          <SearchLink type="offer" />
        </div>
        <section className="h-28 w-full px-6 mt-8 bg-gray-50 flex flex-col justify-start space-y-1 text-center">
          <h1 className="text-md text-gray-600 e-font">Notification</h1>
          {/* TODO 通知を表示する */}
          <div id="user-notification">{/* render 'shared/user_notification' */}通知</div>
        </section>
        <h1 className="w-full pt-4 text-md bg-gray-50 text-gray-600 text-center e-font">Recommendation</h1>
      </div>
      <section className="w-full flex flex-col justify-center items-center space-y-1 pt-4">
        <div id="user-recommendation" className="px-2">
          {/* TODO リコメンデーションを表示、どのようにおすすめしているかわかりやすいように */}
          {/* render partial: 'shared/recommended_offer', collection: @recommended_offers, as: :offer */}
          {/* オファー 一覧 */}
          <section className="mt-4">
            {recommendedOffers.length ? (
              <ol>
                {recommendedOffers.map((offer) => (
                  <li key={offer.id} className="mt-20">
                    <RecommendedOfferItem offer={offer} />
                  </li>
                ))}
              </ol>
            ) : (
              <div className="text-center text-gray-400">
                <p>オファーがありません</p>
              </div>
            )}
          </section>
        </div>
      </section>
      <div className="pb-4 mt-auto">
        <Copyright />
      </div>
    </div>
  )
}
