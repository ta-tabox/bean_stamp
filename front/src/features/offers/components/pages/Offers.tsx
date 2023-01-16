import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'

import { PrimaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Pagination } from '@/components/Elements/Pagination'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { useGetOffers } from '@/features/offers/hooks/useGetOffers'

// TODO Offer一覧ページの作成
export const Offers: FC = memo(() => {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()

  const { offers, getOffers, currentPage, totalPage, loading } = useGetOffers()

  useEffect(() => {
    // オファー 一覧を取得
    getOffers({ page: searchParams.get('page') })
  }, [searchParams])

  const onClickNew = () => {
    navigate('/beans/new')
  }

  return (
    <>
      <Head title="オファー 一覧" />
      <ContentHeader>
        <div className="h-full flex justify-between items-end">
          <ContentHeaderTitle title="オファー 一覧" />
          <PrimaryButton onClick={onClickNew}>新規作成</PrimaryButton>
        </div>
      </ContentHeader>

      {/* ローディング */}
      {loading && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}

      {!loading && (
        <>
          {/* 登録済みのコーヒ豆一覧 */}
          {offers && (
            <section className="mt-4">
              {offers.length ? (
                <>
                  <ol>
                    {offers.map((offer) => (
                      <li key={offer.id}>
                        {/* <BeanItem bean={bean} /> */}
                        <div>{offer.id}</div>
                      </li>
                    ))}
                  </ol>
                  {currentPage && totalPage && <Pagination currentPage={currentPage} totalPage={totalPage} />}
                </>
              ) : (
                <div className="text-center text-gray-400">
                  <p>オファーがありません</p>
                  <Link to="/beans">オファーを作成する</Link>
                </div>
              )}
            </section>
          )}
        </>
      )}
    </>
  )
})
