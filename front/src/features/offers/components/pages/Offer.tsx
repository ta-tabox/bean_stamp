import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { DangerButton, SecondaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Head } from '@/components/Head'
import { BeanCard } from '@/features/beans'
import { OfferCancelModal } from '@/features/offers/components/organisms/OfferCancelModal'
import { useGetOffer } from '@/features/offers/hooks/useGetOffer'
import { OfferCard } from '@/features/offers/organisms/OfferCard'
import { useCurrentRoaster } from '@/features/roasters'
import { useModal } from '@/hooks/useModal'
import { isNumber } from '@/utils/regexp'

export const Offer: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { offer, getOffer } = useGetOffer()
  const { currentRoaster } = useCurrentRoaster()
  const { isOpen, onOpen, onClose } = useModal()

  useEffect(() => {
    if (urlParams.id && isNumber(urlParams.id)) {
      getOffer(urlParams.id)
    } else {
      navigate('/')
    }
  }, [urlParams.id])

  const onClickEdit = () => {
    if (offer) {
      // const editUrl = `/offer/${offer.id}/edit`
      // navigate(editUrl)
      alert('編集の導線どうする？')
    }
  }

  const onClickDelete = () => {
    onOpen()
  }
  return (
    <>
      <Head title="オファー詳細" />
      <ContentHeader>
        <div className="h-full flex flex-col sm:flex-row justify-between sm:items-end">
          <ContentHeaderTitle title="オファー詳細" />
          {offer && offer.roasterId === currentRoaster?.id && (
            <div className="flex items-end ml-auto space-x-2">
              <SecondaryButton onClick={onClickEdit}>編集</SecondaryButton>
              <DangerButton onClick={onClickDelete}>削除</DangerButton>
            </div>
          )}
        </div>
      </ContentHeader>

      <section className="mt-8 mb-20">
        {offer && (
          <>
            <section className="mt-16">
              <OfferCard offer={offer} />
            </section>

            <section className="mt-8 mb-20">
              <BeanCard bean={offer.bean} />
            </section>
            <OfferCancelModal offer={offer} isOpen={isOpen} onClose={onClose} />
          </>
        )}
      </section>
    </>
  )
}
