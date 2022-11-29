import type { FC } from 'react'
import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { ContentHeader } from '@/components/Elements/Header'
import { ContentHeaderTitle } from '@/components/Elements/Header/ContentHeaderTitle'
import { Spinner } from '@/components/Elements/Spinner'
import { useAuth } from '@/features/auth'
import { getUser } from '@/features/users/api/getUser'
import { UserCard } from '@/features/users/components/organisms/UserCard'
import type { User as UserType } from '@/features/users/types'
import { useMessage } from '@/hooks/useMessage'

export const User: FC = () => {
  const [user, setUser] = useState<UserType>()
  const [loading, setLoading] = useState(false)
  const urlParams = useParams<{ id: string }>()
  const { authHeaders } = useAuth()
  const { showMessage } = useMessage()
  const navigate = useNavigate()

  useEffect(() => {
    // urlParams.idが数値かどうか評価
    if (urlParams.id && !Number.isNaN(parseInt(urlParams.id, 10))) {
      setLoading(true)
      getUser({ headers: authHeaders, id: urlParams.id })
        .then((response) => {
          setUser(response.data)
        })
        .catch(() => {
          navigate('/')
          showMessage({ message: 'ユーザーが存在しません', type: 'error' })
        })
        .finally(() => {
          setLoading(false)
        })
    } else {
      navigate('/')
    }
  }, [urlParams.id])

  return (
    <>
      <ContentHeader>
        <div className="h-full flex justify-start items-end">
          <ContentHeaderTitle title="ユーザー詳細" />
        </div>
      </ContentHeader>

      <section>
        {loading && (
          <div className="flex justify-center">
            <Spinner />
          </div>
        )}
        {!loading && user && <UserCard user={user} />}
      </section>
    </>
  )
}
