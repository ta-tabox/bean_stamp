import type { FC } from 'react'
import { useState } from 'react'
import { Link } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { BeanImagesSwiper, BeanTasteTags } from '@/features/beans'
import { LikeUnLikeButton } from '@/features/likes'
import { OfferContentTab } from '@/features/offers/components/molecules/OfferContentTab'
import { OfferPricePerWeight } from '@/features/offers/components/molecules/OfferPricePerWeight'
import { OfferStatusTag } from '@/features/offers/components/molecules/OfferStatusTag'
import { OfferWantedUserStats } from '@/features/offers/components/molecules/OfferWantedUserStats'
import type { Offer } from '@/features/offers/types'
import { RoasterNameLink, RoasterThumbnail, useCurrentRoaster } from '@/features/roasters'
import { WantUnWantButton } from '@/features/wants'

type Props = {
  offer: Offer
}

export const OfferContentCard: FC<Props> = (props) => {
  const { offer } = props
  const { id, status, amount, price, weight, bean, roaster, want } = offer

  const { currentRoaster } = useCurrentRoaster()

  const [wantId, setWantId] = useState<number | null>(want.id || null)
  const [wantCount, setWantCount] = useState<number>(want.count)

  return (
    <article className="text-gray-600">
      <Card>
        <header>
          <div className="w-11/12 mb-2 mx-auto">
            <div className="flex justify-center -mt-16 lg:justify-end">
              <Link to={`/roasters/${roaster.id}`}>
                <RoasterThumbnail name={roaster.name} thumbnailUrl={roaster.thumbnailUrl} />
              </Link>
            </div>
            <div className="flex flex-col md:flex-row justify-between items-center my-2">
              <div className="w-full md:w-auto flex flex-col md:flex-row justify-between items-start md:items-center order-2 md:order-1">
                <div className="-mt-6 md:mt-0 md:mr-4">
                  <OfferStatusTag status={status} />
                </div>
                <div className="mt-4 md:mt-0">
                  <BeanTasteTags tastes={bean.taste.names} />
                </div>
              </div>
              <div className="order-1 md:order-2 flex-1 w-2/3 md:w-1/3 ml-auto">
                <RoasterNameLink id={roaster.id} name={roaster.name} />
              </div>
            </div>
            <Link to={`/offers/${id}`}>
              <h1 className="inline-block mb-2 text-gray-800 text-lg md:text-2xl title-font">{bean.name}</h1>
            </Link>
            <div className="flex justify-between items-end">
              <div className="flex space-x-2">
                {roaster.id !== currentRoaster?.id && (
                  <>
                    <WantUnWantButton
                      offerId={id}
                      wantId={wantId}
                      setWantId={setWantId}
                      wantCount={wantCount}
                      setWantCount={setWantCount}
                    />
                    <LikeUnLikeButton />
                  </>
                )}
              </div>
              <div className="mr-4">
                <OfferWantedUserStats offerId={id} roasterId={roaster.id} count={wantCount} amount={amount} />
              </div>
            </div>
          </div>
        </header>

        <div className="w-11/12 mx-auto flex flex-wrap mt-4">
          <div className="w-full lg:w-1/2 lg:pr-4 mb-4 lg:mb-0">
            <OfferContentTab offer={offer} />
            {/* 価格 */}
            <div className="pt-4 flex justify-end">
              <OfferPricePerWeight price={price} weight={weight} />
            </div>
          </div>

          {/* 画像  */}
          <div className="w-full lg:w-1/2 h-64 md:h-96 lg:h-auto">
            <BeanImagesSwiper beanName={bean.name} imageUrls={bean.imageUrls} />
          </div>
        </div>
      </Card>
    </article>
  )
}
