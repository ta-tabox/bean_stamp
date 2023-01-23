import type { FC } from 'react'
import { Link } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { BeanDetail, BeanImagesSwiper, BeanTasteChart, BeanTasteTags } from '@/features/beans'
import { LikeUnLikeButton } from '@/features/likes'
import { OfferPricePerWeight } from '@/features/offers/components/molecules/OfferPricePerWeight'
import { OfferSchedule } from '@/features/offers/components/molecules/OfferSchedule'
import { OfferStatusTag } from '@/features/offers/components/molecules/OfferStatusTag'
import { OfferWantedUserStats } from '@/features/offers/components/molecules/OfferWantedUserStats'
import type { Offer } from '@/features/offers/types'
import { RoasterNameLink, RoasterThumbnail } from '@/features/roasters'
import { WantUnWantButton } from '@/features/wants'

type Props = {
  offer: Offer
}

export const OfferContentCard: FC<Props> = (props) => {
  const { offer } = props
  const { id, status, roaster, amount, price, weight, wantCount, bean } = offer

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
              <h1 className="mb-2 text-gray-800 text-lg md:text-2xl title-font">{bean.name}</h1>
            </Link>
            <div className="flex justify-between items-end">
              <div className="flex space-x-2">
                <WantUnWantButton />
                <LikeUnLikeButton />
              </div>
              <div className="mr-4">
                <OfferWantedUserStats offerId={id} roasterId={roaster.id} count={wantCount} amount={amount} />
              </div>
            </div>
          </div>
        </header>

        {/* TODO タグ機能の実装 */}
        <div className="w-11/12 mx-auto flex flex-wrap">
          <div className="tab-panel w-full lg:w-1/2 lg:pr-4 mb-4 lg:mb-0">
            <ul className="tab-group">
              <li className="offer-overview-tag py-2 text-lg px-1 tab is-active e-font">Overview</li>
              <li className="offer-taste-tag py-2 text-lg px-1 tab e-font">Taste</li>
              <li className="offer-schedule-tag py-2 text-lg px-1 tab e-font">Schedule</li>
            </ul>

            {/* コンテンツ */}
            <div className="panel-group w-full lg:h-80">
              {/* 詳細 */}
              <section className="offer-overview panel is-show">
                <BeanDetail bean={bean} />
              </section>

              {/* テイストチャート */}
              <section className="offer-taste panel">
                <div className="max-w-sm mx-auto">
                  <BeanTasteChart
                    acidity={bean.acidity}
                    flavor={bean.flavor}
                    body={bean.body}
                    bitterness={bean.bitterness}
                    sweetness={bean.sweetness}
                  />
                </div>
              </section>

              {/* スケジュール */}
              <section className="offer-schedule panel">
                <OfferSchedule offer={offer} />
              </section>
            </div>

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
