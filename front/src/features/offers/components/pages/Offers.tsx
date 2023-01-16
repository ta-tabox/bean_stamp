import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'

import { PrimaryButton } from '@/components/Elements/Button'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Link } from '@/components/Elements/Link'
import { Pagination } from '@/components/Elements/Pagination'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { BeanItem } from '@/features/beans/components/organisms/BeanItem'
import { useGetBeans } from '@/features/beans/hooks/useGetBeans'

// TODO Offer一覧ページの作成
export const Offers: FC = memo(() => {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()

  const { beans, getBeans, currentPage, totalPage, loading } = useGetBeans()

  useEffect(() => {
    // コーヒー豆一覧を取得
    getBeans({ page: searchParams.get('page') })
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
          {beans && (
            <section className="mt-4">
              {beans.length ? (
                <>
                  <ol>
                    {beans.map((bean) => (
                      <li key={bean.id}>
                        <BeanItem bean={bean} />
                      </li>
                    ))}
                  </ol>
                  {currentPage && totalPage && <Pagination currentPage={currentPage} totalPage={totalPage} />}
                </>
              ) : (
                <div className="text-center text-gray-400">
                  <p>オファーがありませんん</p>
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
