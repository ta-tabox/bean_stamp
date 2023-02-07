import type { FC } from 'react'
import { useNavigate, Link } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { BeanDetail, BeanTasteTags } from '@/features/beans'
import type { Like } from '@/features/likes/types'
import { OfferPricePerWeight, OfferSchedule, OfferStatusTag, OfferWantedUserStats } from '@/features/offers'
import { RoasterNameLink, RoasterThumbnail } from '@/features/roasters'

type Props = {
  like: Like
}

// TODO スタイル調整
export const IndexLikeCard: FC<Props> = (props) => {
  const { like } = props
  const { offer } = like
  const { id, status, roaster, amount, price, weight, bean, want } = offer

  const navigate = useNavigate()

  const onClickShow = () => {
    navigate(`/offers/${offer.id}`)
  }

  return (
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
            {/* TODO ボタンどうする？ */}
            {/* <div className="flex space-x-1">
                {roaster.id !== currentRoaster?.id && (
                  <>
                    <WantUnWantButton
                      offer={offer}
                      wantId={wantId}
                      setWantId={setWantId}
                      wantCount={wantCount}
                      setWantCount={setWantCount}
                    />
                    <LikeUnLikeButton offer={offer} likeId={likeId} setLikeId={setLikeId} />
                  </>
                )}
              </div> */}
            <div className="mr-4">
              <OfferWantedUserStats offerId={id} roasterId={roaster.id} count={want.count} amount={amount} />
            </div>
          </div>
        </div>
      </header>
      <div className="mt-4 lg:grid content-between grid-cols-2">
        {/* NOTE モバイルで見にくいのでタブ表示にしてもいいかも */}
        <BeanDetail bean={bean} />
        <OfferSchedule offer={offer} />
        <div className="col-span-2 w-11/12 lg:w-full mx-auto pr-2 flex justify-end">
          <OfferPricePerWeight price={price} weight={weight} />
        </div>
      </div>
    </Card>
  )
}
