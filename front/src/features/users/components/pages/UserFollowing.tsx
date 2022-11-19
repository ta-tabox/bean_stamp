import type { FC } from 'react'
import { useState, useEffect, memo } from 'react'
import { useNavigate, useParams } from 'react-router-dom'

import { Card } from '@/components/Elements/Card'
import { Spinner } from '@/components/Elements/Spinner'
import { Head } from '@/components/Head'
import { useAuth } from '@/features/auth'
import type { Roaster } from '@/features/roasters'
import defaultRoasterImage from '@/features/roasters/assets/defaultRoaster.png'
import { RoasterItem } from '@/features/roasters/components/organisms/RoasterItem'
import { getRoastersFollowedByUser } from '@/features/users/api/getRoastersFollowedByUser'
import { useMessage } from '@/hooks/useMessage'
import { translatePrefectureCodeToName } from '@/utils/prefecture'

export const UserFollowing: FC = memo(() => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { authHeaders } = useAuth()
  const { showMessage } = useMessage()

  const [roasters, setRoasters] = useState<Array<Roaster>>([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    if (urlParams.id && !Number.isNaN(parseInt(urlParams.id, 10))) {
      setLoading(true)
      getRoastersFollowedByUser({ headers: authHeaders, id: urlParams.id })
        .then((response) => {
          setRoasters(response.data)
        })
        .catch(() => {
          navigate('/')
          showMessage({ message: 'ユーザーが存在しません', type: 'error' })
        })
        .finally(() => {
          setLoading(false)
        })
    }
  }, [])

  const handleClickRoaster = (id: number) => {
    alert(`RoasterId: ${id}`)
  }

  return (
    <>
      <Head title="フォロー" />
      {/* TODO ユーザー情報を載せる User.tsxを参考に */}
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
                    imageUrl={roaster.image.url ? `${roaster.image.url}` : defaultRoasterImage}
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
