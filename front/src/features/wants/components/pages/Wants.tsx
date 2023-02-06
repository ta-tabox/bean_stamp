import type { FC } from 'react'
import { useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'

import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Pagination } from '@/components/Elements/Pagination'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { OfferStatusFilterForm } from '@/features/offers'
import { IndexWantCard } from '@/features/wants/components/organisms/IndexWantCard'
import { useGetWants } from '@/features/wants/hooks/useGetWants'
import { usePagination } from '@/hooks/usePagination'

export const Wants: FC = () => {
  const [searchParams] = useSearchParams()
  const { wants, getWants, loading } = useGetWants()
  const { currentPage, totalPage } = usePagination()

  useEffect(() => {
    // ウォント 一覧を取得
    void getWants({ page: searchParams.get('page'), status: searchParams.get('status') })
  }, [searchParams])

  return (
    <>
      <Head title="ウォント一覧" />
      <ContentHeader>
        <div className="h-full flex justify-between items-end">
          <ContentHeaderTitle title="ウォント一覧" />
          <OfferStatusFilterForm />
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
          {/* ウォント一覧 */}
          {wants && (
            <section className="mt-4">
              {wants.length ? (
                <>
                  <ol>
                    {wants.map((want) => (
                      <li key={want.id} className="mt-16">
                        <IndexWantCard want={want} />
                      </li>
                    ))}
                  </ol>
                  {currentPage && totalPage && <Pagination currentPage={currentPage} totalPage={totalPage} />}
                </>
              ) : (
                <div className="text-center text-gray-400">
                  <p>ウォントがありません</p>
                  {/* TODO オファー検索へのリンク */}
                  <Link to="/search">オファーを探す</Link>
                </div>
              )}
            </section>
          )}
        </>
      )}
    </>
  )
}