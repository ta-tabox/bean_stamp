import type { FC } from 'react'
import { useState, useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { ContentHeader } from '@/components/Elements/Header'
import { ContentHeaderTitle } from '@/components/Elements/Header/ContentHeaderTitle'
import { SearchLink } from '@/components/Elements/Link'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { useAuth } from '@/features/auth'
import type { Roaster } from '@/features/roasters'
import { RoasterItem } from '@/features/roasters/components/organisms/RoasterItem'
import { getRoastersFollowedByUser } from '@/features/users/api/getRoastersFollowedByUser'
import { getUser } from '@/features/users/api/getUser'
import { UserCard } from '@/features/users/components/organisms/UserCard'
import type { User } from '@/features/users/types'
import { useMessage } from '@/hooks/useMessage'

export const UserFollowing: FC = memo(() => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { authHeaders } = useAuth()
  const { showMessage } = useMessage()

  const [user, setUser] = useState<User>()
  const [roasters, setRoasters] = useState<Array<Roaster>>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    const fetchData = async () => {
      // urlParams.idが数値かどうか評価
      if (urlParams.id && !Number.isNaN(parseInt(urlParams.id, 10))) {
        // urlからユーザー情報を取得
        await getUser({ headers: authHeaders, id: urlParams.id }).then((response) => {
          setUser(response.data)
        })

        // urlからユーザーがフォローしているロースターを取得
        await getRoastersFollowedByUser({ headers: authHeaders, id: urlParams.id }).then((response) => {
          setRoasters(response.data)
        })
      }
    }

    setLoading(true)
    fetchData()
      .catch(() => {
        navigate('/')
        showMessage({ message: 'ユーザーが存在しません', type: 'error' })
      })
      .finally(() => {
        setLoading(false)
      })
  }, [urlParams.id])

  // TODO ロースタークリックした時のアクション, ロースターページへ遷移
  const handleClickRoaster = (id: number) => {
    alert(`RoasterId: ${id}`)
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
      {loading ? (
        <div className="flex justify-center">
          <Spinner />
        </div>
      ) : (
        <>
          {/* ユーザー情報 */}
          {user && <UserCard user={user} />}

          {/* フォローしているロースター一覧 */}
          <section className="mt-4 mb-20 py-4 text-gray-600">
            {roasters.length ? (
              <Card>
                <ol>
                  {roasters.map((roaster) => (
                    <li key={roaster.id}>
                      <RoasterItem roaster={roaster} onClick={handleClickRoaster} />
                    </li>
                  ))}
                </ol>
              </Card>
            ) : (
              <div className="text-center text-gray-400">
                <p>フォローしているロースターがいません</p>
                <div className="mt-4 w-1/2 sm:w-1/3 mx-auto">
                  <SearchLink target="roaster" />
                </div>
              </div>
            )}
          </section>
        </>
      )}
    </>
  )
})
