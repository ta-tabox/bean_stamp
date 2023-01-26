import type { FC } from 'react'
import { useEffect } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'

import { PrimaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Pagination } from '@/components/Elements/Pagination'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { IndexOfferCard } from '@/features/offers/components/organisms/IndexOfferCard'
import { OfferStatusFilterForm } from '@/features/offers/components/organisms/OfferStatusFilterForm'
import { useGetOffers } from '@/features/offers/hooks/useGetOffers'

export const Offers: FC = () => {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()

  const { offers, getOffers, currentPage, totalPage, loading } = useGetOffers()

  useEffect(() => {
    // オファー 一覧を取得
    void getOffers({ page: searchParams.get('page'), status: searchParams.get('status') })
  }, [searchParams])

  const onClickNew = () => {
    navigate('/beans')
  }

  return (
    <>
      <Head title="オファー 一覧" />
      <ContentHeader>
        <div className="h-full flex justify-between items-end">
          <ContentHeaderTitle title="オファー 一覧" />
          <OfferStatusFilterForm />
          <PrimaryButton onClick={onClickNew}>コーヒー豆をオファーする</PrimaryButton>
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
          {/* オファー 一覧 */}
          {offers && (
            <section className="mt-4">
              {offers.length ? (
                <>
                  <ol>
                    {offers.map((offer) => (
                      <li key={offer.id} className="mt-16">
                        <IndexOfferCard offer={offer} />
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
}
