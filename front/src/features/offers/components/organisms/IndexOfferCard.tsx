import type { FC } from 'react'
import { useNavigate } from 'react-router-dom'

import { SecondaryButton } from '@/components/Elements/Button'
import { Card } from '@/components/Elements/Card'
import { BeanThumbnail } from '@/features/beans'
import { OfferPricePerWeight } from '@/features/offers/components/molecules/OfferPricePerWeight'
import { OfferStatusTag } from '@/features/offers/components/molecules/OfferStatusTag'
import { OfferWantedUserStats } from '@/features/offers/components/molecules/OfferWantedUserStats'
import type { Offer } from '@/features/offers/types'
import { getFormattedDate } from '@/features/offers/utils/getFormattedDate'

type Props = {
  offer: Offer
}

export const IndexOfferCard: FC<Props> = (props) => {
  const { offer } = props
  const {
    id,
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

  const navigate = useNavigate()

  const onClickShow = () => {
    navigate(`/offers/${offer.id}`)
  }

  return (
    <Card>
      <div className="px-8">
        <div className="w-11/12 mx-auto">
          <div className="flex justify-center -mt-16 md:justify-end items-end">
            <BeanThumbnail name={bean.name} thumbnailUrl={bean.thumbnailUrl} />
          </div>
          <div className="flex justify-between items-end mb-2">
            <OfferStatusTag status={status} />
            <OfferWantedUserStats offerId={id} roasterId={roaster.id} count={wantCount} amount={amount} />
          </div>
          <div className="md:flex items-baseline">
            <h1 className="md:mt-2 text-xl lg:text-2xl font-medium text-gray-800 lg:mt-0">{bean.name}</h1>
            <div className="md:ml-4 text-right">
              <SecondaryButton onClick={onClickShow}>
                <div className="w-16 md:w-auto">詳細</div>
              </SecondaryButton>
            </div>
          </div>
        </div>
        <div className="mt-4 lg:grid content-between grid-cols-2">
          <div className="grid-item">
            <span className="text-gray-500">生産国</span>
            <span className="ml-auto text-gray-800">{bean.country.name}</span>
          </div>
          <div className="lg:ml-4 grid-item">
            <span className="text-gray-500">焙煎度</span>
            <span className="ml-auto text-gray-800">{bean.roastLevel.name}</span>
          </div>
          <div className="grid-item">
            <span className="text-gray-500">精製方法</span>
            <span className="ml-auto text-gray-800">{bean.process}</span>
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
