import type { FC } from 'react'
import { Link } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { BeanImagesSwiper, BeanTasteChart, BeanTasteTags } from '@/features/beans'
import { LikeUnLikeButton } from '@/features/likes'
import { OfferPricePerWeight } from '@/features/offers/components/molecules/OfferPricePerWeight'
import { OfferStatusTag } from '@/features/offers/components/molecules/OfferStatusTag'
import { OfferWantedUserStats } from '@/features/offers/components/molecules/OfferWantedUserStats'
import type { Offer } from '@/features/offers/types'
import { RoasterNameLink, RoasterThumbnail } from '@/features/roasters'
import { WantUnWantButton } from '@/features/wants'
import { formattedToJaDate } from '@/utils/date'

type Props = {
  offer: Offer
}

export const OfferContentCard: FC<Props> = (props) => {
  const { offer } = props
  const {
    id,
    createdAt,
    endedAt,
    roastedAt,
    receiptStartedAt,
    receiptEndedAt,
    status,
    roaster,
    amount,
    price,
    weight,
    wantCount,
    bean,
  } = offer

  const formatCroppedAt = (croppedAt: string): string => {
    const date = new Date(croppedAt)
    const [year, month] = [date.getFullYear(), date.getMonth()]
    return `${year}年 ${month + 1}月`
  }

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
            {/* TODO コンポーネント化 */}
            {/* コンテンツ */}
            <div className="panel-group w-full lg:h-80">
              {/* 詳細 */}
              <section className="offer-overview panel is-show">
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">生産国</span>
                  <span className="ml-auto text-gray-800">{bean.country.name}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">焙煎度</span>
                  <span className="ml-auto text-gray-800">{bean.roastLevel.name}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">地域</span>
                  <span className="ml-auto text-gray-800">{bean.subregion}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">農園</span>
                  <span className="ml-auto text-gray-800">{bean.farm}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">品種</span>
                  <span className="ml-auto text-gray-800">{bean.variety}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">精製方法</span>
                  <span className="ml-auto text-gray-800">{bean.process}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">標高</span>
                  <span className="ml-auto text-gray-800">{bean.elevation && `${bean.elevation} m`} </span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">収穫</span>
                  <span className="ml-auto text-gray-800">{bean.croppedAt && formatCroppedAt(bean.croppedAt)}</span>
                </div>
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
              {/* TODO コンポーネント化 */}
              {/* スケジュール */}
              <section className="offer-schedule panel">
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">オファー作成日</span>
                  <span className="ml-auto text-gray-800">{formattedToJaDate(createdAt)}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">オファー終了日</span>
                  <span className="ml-auto text-gray-800">{formattedToJaDate(endedAt)}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">焙煎日</span>
                  <span className="ml-auto text-gray-800">{formattedToJaDate(roastedAt)}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">受け取り開始日</span>
                  <span className="ml-auto text-gray-800">{formattedToJaDate(receiptStartedAt)}</span>
                </div>
                <div className="flex border-t border-gray-200 py-2">
                  <span className="text-gray-500">受け取り終了日</span>
                  <span className="ml-auto text-gray-800">{formattedToJaDate(receiptEndedAt)}</span>
                </div>
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
