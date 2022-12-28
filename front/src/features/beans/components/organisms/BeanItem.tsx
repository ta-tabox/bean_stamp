import type { FC } from 'react'
import { useNavigate } from 'react-router-dom'

import { PrimaryButton, SecondaryButton } from '@/components/Elements/Button'
import { Card } from '@/components/Elements/Card'
import { BeanInformation } from '@/features/beans/components/molecules/BeanInformation'
import { BeanThumbnail } from '@/features/beans/components/molecules/BeanThumbnail'
import type { Bean } from '@/features/beans/types'

type Props = {
  bean: Bean
}

export const BeanItem: FC<Props> = (props) => {
  const { bean } = props
  const navigate = useNavigate()

  const onClickShow = () => {
    navigate(`/beans/${bean.id}`)
  }

  const onClickOffer = () => {
    alert(`beans-${bean.id}のオファー作成`)
  }

  return (
    //  コーヒー豆一覧アイテム
    <article id={`bean-${bean.id}`} className="pb-4 mt-16">
      <Card>
        <div className="px-4 md:px-6">
          <div className="flex justify-center -mt-16 md:justify-end items-end">
            <BeanThumbnail bean={bean} />
          </div>
          <div className="mt-2 px-4 lg:flex items-baseline md:flex md:justify-between">
            <h1 className="pl-3 lg:pl-0 text-xl lg:text-2xl font-medium text-gray-800">{bean.name}</h1>
            <div className="mt-2 ml-4 flex justify-end space-x-4">
              <PrimaryButton onClick={onClickOffer}>オファー</PrimaryButton>
              <SecondaryButton onClick={onClickShow}>詳細</SecondaryButton>
            </div>
          </div>
          <div className="flex justify-end items-end" />
          <section className="mt-4">
            <BeanInformation bean={bean} />
          </section>
        </div>
      </Card>
    </article>
  )
}
