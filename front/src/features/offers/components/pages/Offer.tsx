import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { DangerButton, SecondaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Head } from '@/components/Head'
import { BeanCancelModal } from '@/features/beans/components/organisms/BeanCancelModal'
import { BeanCard } from '@/features/beans/components/organisms/BeanCard'
import { useGetBean } from '@/features/beans/hooks/useGetBean'
import { useModal } from '@/hooks/useModal'
import { isNumber } from '@/utils/regexp'

// TODO Offerコンテンツの作成
export const Offer: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { bean, getBean } = useGetBean()
  const { isOpen, onOpen, onClose } = useModal()

  useEffect(() => {
    if (urlParams.id && isNumber(urlParams.id)) {
      getBean(urlParams.id)
    } else {
      navigate('/roasters/home')
    }
  }, [urlParams.id])

  const onClickEdit = () => {
    if (bean) {
      const editUrl = `/beans/${bean.id}/edit`
      navigate(editUrl)
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
          <div className="flex items-end ml-auto space-x-2">
            <SecondaryButton onClick={onClickEdit}>編集</SecondaryButton>
            <DangerButton onClick={onClickDelete}>削除</DangerButton>
          </div>
        </div>
      </ContentHeader>

      <section className="mt-8 mb-20">
        {bean && (
          <>
            <BeanCard bean={bean} />
            <BeanCancelModal bean={bean} isOpen={isOpen} onClose={onClose} />
          </>
        )}
      </section>
    </>
  )
}
