import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { Spinner } from '@/components/Elements/Spinner'
import { useGetUsersFollowingToRoaster } from '@/features/roasters/hooks/useGetUsersFollowingToRoaster'
import { UserItem } from '@/features/users/components/organisms/UserItem'
import { isNumber } from '@/utils/regexp'

export const RoasterOffers: FC = memo(() => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { usersFollowingToRoaster, getUsersFollowingToRoaster, loading: usersLoading } = useGetUsersFollowingToRoaster()

  useEffect(() => {
    const fetchData = (id: string) => {
      // urlからユーザーがフォローしているロースターを取得
      getUsersFollowingToRoaster(id)
    }

    // urlParams.idが数値かどうか評価
    if (urlParams.id && isNumber(urlParams.id)) {
      fetchData(urlParams.id)
    }
  }, [urlParams.id])

  const onClickOffer = (id: number) => {
    alert(`ここにオファー${id}`)
  }

  return (
    <>
      {/* ローディング */}
      {usersLoading && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}

      {!usersLoading && (
        <>
          {/* TODO ロースターのオファー一覧を表示する */}
          {usersFollowingToRoaster && (
            <section className="mb-20 py-4 text-gray-600">
              <div>RoasterOffersコンポーネント</div>
              {usersFollowingToRoaster.length ? (
                <Card>
                  <ol>
                    {usersFollowingToRoaster.map((user) => (
                      <li key={user.id}>
                        <UserItem user={user} onClick={onClickOffer} />
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
