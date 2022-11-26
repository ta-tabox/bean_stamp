import type { FC } from 'react'
import { useState, useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { ContentHeader } from '@/components/Elements/Header'
import { ContentHeaderTitle } from '@/components/Elements/Header/ContentHeaderTitle'
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
import { translatePrefectureCodeToName } from '@/utils/prefecture'

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
        await getUser(authHeaders, urlParams.id).then((response) => {
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
  }, [])

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

      {/* ユーザー情報 */}
      <section>{!loading && user && <UserCard user={user} />}</section>

      {/* フォローしているロースター一覧 */}
      <section className="mt-4 mb-20 py-4 text-gray-600">
        <Card>
          {!loading && (
            <ol>
              {roasters.map((roaster) => (
                <li key={roaster.id}>
                  <RoasterItem
                    id={roaster.id}
                    roasterName={roaster.name}
                    area={translatePrefectureCodeToName(roaster.prefectureCode)}
                    address={roaster.address}
                    describe={roaster.describe ?? ''}
                    imageUrl={roaster.image.url}
                    onClick={handleClickRoaster}
                  />
                </li>
              ))}
            </ol>
          )}
          {loading && (
            <div className="flex justify-center">
              <Spinner />
            </div>
          )}
        </Card>
      </section>
    </>
  )
})
