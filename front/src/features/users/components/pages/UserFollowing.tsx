import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { SearchLink } from '@/components/Elements/Link'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { RoasterItem } from '@/features/roasters/components/organisms/RoasterItem'
import { UserCard } from '@/features/users/components/organisms/UserCard'
import { useGetRoastersFollowedByUser } from '@/features/users/hooks/useGetRoastersFollowedByUser'
import { useGetUser } from '@/features/users/hooks/useGetUser'
import { isNumber } from '@/utils/regexp'

export const UserFollowing: FC = memo(() => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { user, getUser, loading: userLoading } = useGetUser()
  const { roasters, getRoastersFollowedByUser, loading: roastersLoading } = useGetRoastersFollowedByUser()

  useEffect(() => {
    const fetchData = (id: string) => {
      // urlからユーザー情報を取得
      getUser(id)
      // urlからユーザーがフォローしているロースターを取得
      getRoastersFollowedByUser(id)
    }

    // urlParams.idが数値かどうか評価
    if (urlParams.id && isNumber(urlParams.id)) {
      fetchData(urlParams.id)
    }
  }, [urlParams.id])

  const onClickRoaster = (id: number) => {
    navigate(`/roasters/${id}`)
  }

  return (
    <>
      <Head title="フォロー" />
      <ContentHeader>
        <div className="h-full flex justify-start items-end">
          <ContentHeaderTitle title="フォロー" />
        </div>
      </ContentHeader>

      {/* ローディング */}
      {(userLoading || roastersLoading) && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}

      {!userLoading && !roastersLoading && (
        <>
          {/* ユーザー情報 */}
          {user && <UserCard user={user} />}

          {/* フォローしているロースター一覧 */}
          {roasters && (
            <section className="mt-4 mb-20 py-4 text-gray-600">
              {roasters.length ? (
                <Card>
                  <ol>
                    {roasters.map((roaster) => (
                      <li key={roaster.id}>
                        <RoasterItem roaster={roaster} onClick={onClickRoaster} />
                      </li>
                    ))}
                  </ol>
                </Card>
              ) : (
                <div className="text-center text-gray-400">
                  <p>フォローしているロースターがいません</p>
                  <div className="mt-4 w-1/2 sm:w-1/3 mx-auto">
                    <SearchLink type="roaster" />
                  </div>
                </div>
              )}
            </section>
          )}
        </>
      )}
    </>
  )
})
