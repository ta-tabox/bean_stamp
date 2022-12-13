import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { ContentHeader } from '@/components/Elements/Header'
import { ContentHeaderTitle } from '@/components/Elements/Header/ContentHeaderTitle'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { RoasterCard } from '@/features/roasters/components/organisms/RoasterCard'
import { useGetRoaster } from '@/features/roasters/hooks/useGetRoaster'
import { useGetUsersFollowingToRoaster } from '@/features/roasters/hooks/useGetUsersFollowingToRoaster'
import { UserItem } from '@/features/users/components/organisms/UserItem'
import { isNumber } from '@/utils/regexp'

export const RoasterFollower: FC = memo(() => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { roaster, getRoaster, loading: roasterLoading } = useGetRoaster()
  const { users, getUsersFollowingToRoaster, loading: usersLoading } = useGetUsersFollowingToRoaster()

  useEffect(() => {
    const fetchData = (id: string) => {
      // urlからユーザー情報を取得
      // TODO ロースターと一緒に、followersを取得, 最終的にはgetRoasterWithFollowerAndOffersでデータを引っ張ってくる
      getRoaster(id)
      // urlからユーザーがフォローしているロースターを取得
      getUsersFollowingToRoaster(id)
    }

    // urlParams.idが数値かどうか評価
    if (urlParams.id && isNumber(urlParams.id)) {
      fetchData(urlParams.id)
    }
  }, [urlParams.id])

  const handleClickUser = (id: number) => {
    navigate(`/users/${id}`)
  }

  return (
    <>
      <Head title="フォロワー" />
      <ContentHeader>
        <div className="h-full flex justify-start items-end">
          <ContentHeaderTitle title="フォロワー" />
        </div>
      </ContentHeader>

      {/* ローディング */}
      {(roasterLoading || usersLoading) && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}

      {!roasterLoading && !usersLoading && (
        <>
          {/* ロースター情報 */}
          {roaster && <RoasterCard roaster={roaster} />}
          {/* TODO この上まで一緒なので、Roasterコンポーネントと合わせてこれ以下をルーティングで切り替えることができるか？ followerになるとユーザー一覧コンポーネントを出す。 */}

          {/* フォローされているユーザー一覧 */}
          {users && (
            <section className="mt-4 mb-20 py-4 text-gray-600">
              {users.length ? (
                <Card>
                  <ol>
                    {users.map((user) => (
                      <li key={user.id}>
                        <UserItem user={user} onClick={handleClickUser} />
                      </li>
                    ))}
                  </ol>
                </Card>
              ) : (
                <div className="text-center text-gray-400">
                  <p>フォローしているユーザーがいません</p>
                </div>
              )}
            </section>
          )}
        </>
      )}
    </>
  )
})
