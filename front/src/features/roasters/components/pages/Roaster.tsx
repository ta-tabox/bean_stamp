import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { ContentHeader } from '@/components/Elements/Header'
import { ContentHeaderTitle } from '@/components/Elements/Header/ContentHeaderTitle'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { RoasterCard } from '@/features/roasters/components/organisms/RoasterCard'
import { useGetRoaster } from '@/features/roasters/hooks/useGetRoaster'
import { isNumber } from '@/utils/regexp'

export const Roaster: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { roaster, getRoaster, loading } = useGetRoaster()

  useEffect(() => {
    if (urlParams.id && isNumber(urlParams.id)) {
      getRoaster(urlParams.id)
    } else {
      navigate('/roasters/home')
    }
  }, [urlParams.id])

  return (
    <>
      <Head title="ロースター詳細" />
      <ContentHeader>
        <div className="h-full flex justify-start items-end">
          <ContentHeaderTitle title="ロースター詳細" />
        </div>
      </ContentHeader>

      <section>
        {loading && (
          <div className="flex justify-center">
            <Spinner />
          </div>
        )}

        {!loading && roaster && <RoasterCard roaster={roaster} />}
        {/* TODO ロースターのオファー一覧を表示する */}
      </section>
    </>
  )
}
