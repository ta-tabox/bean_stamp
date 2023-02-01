import type { FC } from 'react'
import { useNavigate } from 'react-router-dom'

import { SecondaryButton } from '@/components/Elements/Button'
import { Card } from '@/components/Elements/Card'
import { BeanDetail } from '@/features/beans'
import { OfferPricePerWeight, OfferSchedule, OfferStatusTag } from '@/features/offers'
import { RoasterNameLink, RoasterThumbnail } from '@/features/roasters'
import type { Want } from '@/features/wants/type'

type Props = {
  want: Want
}

export const IndexWantCard: FC<Props> = (props) => {
  const { want } = props
  const { offer } = want
  const { status, roaster, price, weight, bean } = offer

  const navigate = useNavigate()

  const onClickShow = () => {
    navigate(`/wants/${want.id}`)
  }

  return (
    <Card>
      <div className="px-8">
        <div className="w-11/12 mx-auto">
          <div className="flex justify-center -mt-16 md:justify-end items-end">
            <RoasterThumbnail name={roaster.name} thumbnailUrl={roaster.thumbnailUrl} />
          </div>
          <div className="flex justify-between items-end mb-2">
            <OfferStatusTag status={status} />
            {/* TODO 受け取り完了バッジ */}
            <OfferStatusTag status={status} />
            <div className="flex-1 w-2/3 md:w-1/3 ml-auto">
              <RoasterNameLink id={roaster.id} name={roaster.name} />
            </div>
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
          {/* NOTE モバイルで見にくいのでタブ表示にしてもいいかも */}
          <BeanDetail bean={bean} />
          <OfferSchedule offer={offer} />
          <div className="col-span-2 w-11/12 lg:w-full mx-auto pr-2 flex justify-end">
            <OfferPricePerWeight price={price} weight={weight} />
          </div>
        </div>
      </div>
    </Card>
  )
}
