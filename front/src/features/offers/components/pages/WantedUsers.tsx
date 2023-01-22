import type { FC } from 'react'
import { useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { ContentHeader, ContentHeaderTitle } from '@/components/Elements/Content'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { OfferCard } from '@/features/offers/components/organisms/OfferCard'
import { useGetOffer } from '@/features/offers/hooks/useGetOffer'
import { useGetUsersWantedToOffer } from '@/features/offers/hooks/useGetUsersWantedToOffer'
import { UserItem } from '@/features/users/components/organisms/UserItem'
import { isNumber } from '@/utils/regexp'

export const WantedUsers: FC = memo(() => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { getOffer, offer, loading: offerLoading } = useGetOffer()
  const { usersWantedToOffer: users, getUsersWantedToOffer, loading: usersLoading } = useGetUsersWantedToOffer()

  useEffect(() => {
    const fetchData = (id: string) => {
      // urlからオファー情報を取得
      getOffer(id)
      // urlからオファーをウォンツしているユーザー一覧を取得
      getUsersWantedToOffer(id)
    }

    // urlParams.idが数値かどうか評価
    if (urlParams.id && isNumber(urlParams.id)) {
      fetchData(urlParams.id)
    }
  }, [urlParams.id])

  const onClickUser = (id: number) => {
    navigate(`/users/${id}`)
  }

  return (
    <>
      <Head title="ウォンツしたユーザー" />
      <ContentHeader>
        <div className="h-full flex justify-start items-end">
          <ContentHeaderTitle title="ウォンツしたユーザー" />
        </div>
      </ContentHeader>

      {/* ローディング */}
      {(offerLoading || usersLoading) && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}

      {!offerLoading && !usersLoading && (
        <>
          {/* オファー情報 */}
          {offer && (
            <section className="mt-16">
              <OfferCard offer={offer} />
            </section>
          )}

          {/* ウォンツしているユーザー一覧 */}
          {users && (
            <section className="mt-4 mb-20 py-4 text-gray-600">
              {users.length ? (
                <Card>
                  <ol>
                    {users.map((user) => (
                      <li key={user.id}>
                        <UserItem user={user} onClick={onClickUser} />
                      </li>
                    ))}
                  </ol>
                </Card>
              ) : (
                <div className="text-center text-gray-400">
                  <p>ウォンツしているユーザーがいません</p>
                </div>
              )}
            </section>
          )}
        </>
      )}
    </>
  )
})
