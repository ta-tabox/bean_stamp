import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { PrimaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Head } from '@/components/Head'
import { BeanCard } from '@/features/beans'
import { OfferDetailCard } from '@/features/offers'
import { useGetWant } from '@/features/wants/hooks/useGetWant'
import { useModal } from '@/hooks/useModal'
import { isNumber } from '@/utils/regexp'

export const Want: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()

  const { want, getWant } = useGetWant()
  const { isOpen: isOpenDelete, onOpen: onOpenDelete, onClose: onCloseDelete } = useModal()

  useEffect(() => {
    if (urlParams.id && isNumber(urlParams.id)) {
      getWant(urlParams.id)
    } else {
      navigate('/')
    }
  }, [urlParams.id])

  const onClickReceive = () => {
    alert('受け取り処理と評価')
  }

  return (
    <>
      <Head title="ウォンツ詳細" />
      <ContentHeader>
        <div className="h-full flex flex-col sm:flex-row justify-between sm:items-end">
          <ContentHeaderTitle title="ウォンツ詳細" />
          <Link to="/wants">一覧へ戻る</Link>
        </div>
      </ContentHeader>

      <section className="mt-8 mb-20">
        {want && (
          <>
            {/* TODO 評価モーダル */}
            <div className="text-center">
              <PrimaryButton onClick={onClickReceive}>受け取り完了</PrimaryButton>
            </div>
            <section className="mt-16">
              <OfferDetailCard offer={want.offer} />
            </section>

            <section className="mt-8 mb-20">
              <BeanCard bean={want.offer.bean} />
            </section>
          </>
        )}
      </section>
    </>
  )
}
