import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useSearchParams } from 'react-router-dom'

import { LoadingButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Pagination } from '@/components/Elements/Pagination'
import { Head } from '@/components/Head'
import { useLoadUser } from '@/features/auth'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { OfferContentCard } from '@/features/offers'
import { useGetCurrentOffers } from '@/features/users/hooks/useGetCurrentOffers'
import { usePagination } from '@/hooks/usePagination'

export const UserHome: FC = memo(() => {
  const { signedInUser } = useSignedInUser()
  const { loadUser } = useLoadUser()
  const { currentOffers, getCurrentOffers, loading } = useGetCurrentOffers()
  const { currentPage, totalPage } = usePagination()
  const [searchParams, setSearchParams] = useSearchParams()

  // NOTE サインイン直後のユーザー＆ロースター情報の更新はここでOKか？
  useEffect(() => {
    void loadUser()
  }, [])

  useEffect(() => {
    // フォローしているロースターのオファー一覧を取得
    getCurrentOffers({ page: searchParams.get('page') })
  }, [searchParams])

  const onClickReload = () => {
    getCurrentOffers({ page: null })
    setSearchParams({})
  }

  return (
    <>
      <Head title="ホーム" />
      <ContentHeader>
        <div className="h-full flex justify-between items-end">
          <ContentHeaderTitle title={`${signedInUser?.name ?? ''}のホーム`} />
        </div>
      </ContentHeader>

      {/* オファー更新ボタン */}
      <LoadingButton onClick={onClickReload} loading={loading} />

      {!loading && (
        <>
          {/* オファー 一覧 */}
          {currentOffers && (
            <section className="mt-4">
              {currentOffers.length ? (
                <>
                  <ol>
                    {currentOffers.map((offer) => (
                      <li key={offer.id} className="mt-20">
                        <OfferContentCard offer={offer} />
                      </li>
                    ))}
                  </ol>
                  {currentPage && totalPage && <Pagination currentPage={currentPage} totalPage={totalPage} />}
                </>
              ) : (
                <div className="text-center text-gray-400">
                  <p>オファーがありません</p>
                  <Link to="/search">ロースターをフォローしてオファーを受け取る</Link>
                </div>
              )}
            </section>
          )}
        </>
      )}
    </>
  )
})
