import type { FC } from 'react'
import { useLayoutEffect } from 'react'
import { useLocation } from 'react-router-dom'

import { Copyright } from '@/components/Elements/Copyright'
import { SearchLink } from '@/components/Elements/Link'
import { useSignedInUser } from '@/features/auth'
import { useRandomSelectRecommendedOffers, RecommendedOfferItem, useGetRecommendedOffers } from '@/features/offers'
import { useGetWantsStats } from '@/features/wants'

export const UserAsideContent: FC = () => {
  const location = useLocation()
  const { recommendedOffers, randomSelectRecommendedOffers, recommendedOffersPool } = useRandomSelectRecommendedOffers()

  const { getRecommendedOffers } = useGetRecommendedOffers()
  const { signedInUser } = useSignedInUser()
  const { wantsStats, getWantsStats } = useGetWantsStats()

  useLayoutEffect(() => {
    if (signedInUser) {
      getRecommendedOffers()
    }
  }, [signedInUser])

  useLayoutEffect(() => {
    randomSelectRecommendedOffers()
  }, [location, recommendedOffersPool])

  useLayoutEffect(() => {
    getWantsStats()
  }, [signedInUser])

  return (
    <div className="min-h-screen h-auto w-full flex flex-col items-center">
      <div className="w-full sticky top-0 bg-gray-50 z-50">
        <div className="w-44 mt-10 mx-auto">
          <SearchLink type="offer" />
        </div>
        <section className="h-28 w-full px-6 mt-8 bg-gray-50 flex flex-col justify-start space-y-1 text-center">
          <h1 className="text-md text-gray-600 e-font">Notification</h1>
          {/* TODO 通知を表示する */}
          <div>{/* render 'shared/user_notification' */}</div>
          <div>{wantsStats?.onOffering}</div>
        </section>
        <h1 className="w-full pt-4 text-md bg-gray-50 text-gray-600 text-center e-font">Recommendation</h1>
      </div>
      <section className="w-full flex flex-col justify-center items-center space-y-1 mt-2">
        <div className="px-2">
          {/* おすすめのオファー 一覧 */}
          {/* TODO おすすめのオファーのタイプで表示を変える 風味 or 近い
          apiより選択条件を返す */}
          {recommendedOffers.length ? (
            <>
              <h2 className="text-sm text-gray-500 mx-4 text-center">
                あなたの好きな風味の
                <br />
                コーヒーはいかがですか？
              </h2>
              <ol className="mt-2">
                {recommendedOffers.map((offer) => (
                  <li key={offer.id} className="mb-4">
                    <RecommendedOfferItem offer={offer} />
                  </li>
                ))}
              </ol>
            </>
          ) : (
            <div className="text-center text-gray-400">
              <p>おすすめのオファーがありません</p>
            </div>
          )}
        </div>
      </section>
      <div className="pb-4 mt-auto">
        <Copyright />
      </div>
    </div>
  )
}
