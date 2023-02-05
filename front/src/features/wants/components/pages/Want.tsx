import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { PrimaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Head } from '@/components/Head'
import { BeanCard } from '@/features/beans'
import { OfferDetailCard } from '@/features/offers'
import { patchWantByReceipt } from '@/features/wants/api/patchWantByReceipt'
import { useGetWant } from '@/features/wants/hooks/useGetWant'
import { useMessage } from '@/hooks/useMessage'
import { useModal } from '@/hooks/useModal'
import { isNumber } from '@/utils/regexp'

export const Want: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()

  const { want, getWant, setWant } = useGetWant()
  const { isOpen: isOpenDelete, onOpen: onOpenDelete, onClose: onCloseDelete } = useModal()
  const { showMessage } = useMessage()

  useEffect(() => {
    if (urlParams.id && isNumber(urlParams.id)) {
      getWant(urlParams.id)
    } else {
      navigate('/')
    }
  }, [urlParams.id])

  const onClickReceive = () => {
    if (want) {
      patchWantByReceipt({ id: want.id })
        .then((response) => {
          setWant(response.data)
          showMessage({ message: '受け取りを完了しました', type: 'success' })
        })
        .catch(() => {
          showMessage({ message: 'すでに受け取りが完了しています', type: 'error' })
        })
    }
  }

  return (
    <>
      <Head title="ウォント詳細" />
      <ContentHeader>
        <div className="h-full flex flex-col sm:flex-row justify-between sm:items-end">
          <ContentHeaderTitle title="ウォント詳細" />
          <Link to="/wants">一覧へ戻る</Link>
        </div>
      </ContentHeader>
      <section className="mt-8 mb-20">
        {want && (
          <>
            {/* TODO 評価モーダル */}
            <div className="text-center">
              <PrimaryButton onClick={onClickReceive} disabled={!!want.receiptedAt}>
                {want.receiptedAt ? '受け取り済み' : '受け取りました！'}
              </PrimaryButton>
              {/* <PrimaryButton onClick={onClickReceive} disabled={want.rate !== 'unrated'}>
                {want.rate !== 'unrated' ? '評価済み' : '評価する'}
              </PrimaryButton> */}
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
