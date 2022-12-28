import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Head } from '@/components/Head'
import { BeanCard } from '@/features/beans/components/organisms/BeanCard'
import { useGetBean } from '@/features/beans/hooks/useGetBean'
import { isNumber } from '@/utils/regexp'

export const Bean: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { bean, getBean } = useGetBean()
  useEffect(() => {
    if (urlParams.id && isNumber(urlParams.id)) {
      getBean(urlParams.id)
    } else {
      navigate('/roasters/home')
    }
  }, [urlParams.id])

  return (
    <>
      <Head title="コーヒー豆詳細" />
      <ContentHeader>
        <div className="h-full flex justify-start items-end">
          <ContentHeaderTitle title="コーヒー豆詳細" />
        </div>
      </ContentHeader>

      <section className="mt-8 mb-20">{bean && <BeanCard bean={bean} />}</section>
    </>
  )
}
