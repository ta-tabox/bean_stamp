import type { FC } from 'react'
import { Link } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { OfferPricePerWeight } from '@/features/offers/components/molecules/OfferPricePerWeight'
import { OfferStatusTag } from '@/features/offers/components/molecules/OfferStatusTag'
import { OfferWantedUserStats } from '@/features/offers/components/molecules/OfferWantedUserStats'
import type { Offer } from '@/features/offers/types'
import { getFormattedDate } from '@/features/offers/utils/getFormattedDate'
import { RoasterNameLink, RoasterThumbnail } from '@/features/roasters'

type Props = {
  offer: Offer
}

export const OfferCard: FC<Props> = (props) => {
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
  } = offer

  return (
    <Card>
      <div className="px-8">
        <div className="w-11/12 mx-auto">
          <div className="flex justify-center -mt-16 md:justify-end">
            <Link to={`/roasters/${roaster.id}`}>
              <RoasterThumbnail name={roaster.name} thumbnailUrl={roaster.thumbUrl} />
            </Link>
          </div>
          <div className="flex justify-between">
            <OfferStatusTag status={status} />
            <RoasterNameLink id={roaster.id} name={roaster.name} />
          </div>
          <div className="flex justify-between items-end">
            {/* TODO want likeボタン */}
            <div className="flex">
              want, link ボタン
              {/* <%= render partial: 'offers/want_form', locals: { offer: offer} %> */}
              {/* <%= render partial: 'offers/like_form', locals: { offer: offer} %> */}
            </div>
            <div className="mr-4">
              <OfferWantedUserStats offerId={id} roasterId={roaster.id} count={wantCount} amount={amount} />
            </div>
          </div>
        </div>
        <div className="mt-4 grid-container grid-cols-2">
          <div className="grid-item">
            <span className="text-gray-500">オファー作成日</span>
            <span className="ml-auto text-gray-800">{getFormattedDate(createdAt)}</span>
          </div>
          <div className="col-start-1 grid-item">
            <span className="text-gray-500">オファー終了日</span>
            <span className="ml-auto text-gray-800">{getFormattedDate(endedAt)}</span>
          </div>
          <div className="lg:ml-4 grid-item">
            <span className="text-gray-500">ロースト日</span>
            <span className="ml-auto text-gray-800">{getFormattedDate(roastedAt)}</span>
          </div>
          <div className="grid-item">
            <span className="text-gray-500">受け取り開始日</span>
            <span className="ml-auto text-gray-800">{getFormattedDate(receiptStartedAt)}</span>
          </div>
          <div className="lg:ml-4 grid-item">
            <span className="text-gray-500">受け取り終了日</span>
            <span className="ml-auto text-gray-800">{getFormattedDate(receiptEndedAt)}</span>
          </div>
          <div className="col-span-2 w-11/12 lg:w-full mx-auto pr-2 flex justify-end">
            <OfferPricePerWeight price={price} weight={weight} />
          </div>
        </div>
      </div>
    </Card>
  )
}
