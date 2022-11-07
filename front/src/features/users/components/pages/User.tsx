import type { FC } from 'react'
import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

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
  const { setAuthHeaders } = useAuth()
  const { showMessage } = useMessage()
  const navigate = useNavigate()

  useEffect(() => {
    const headers = setAuthHeaders()

    if (urlParams.id) {
      setLoading(true)
      getUser(headers, urlParams.id)
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
  }, [])

  return (
    <>
      <header className="header">
        <div className="h-full w-11/12 mx-auto flex justify-start items-end">
          <h1 className="page-title">ユーザー詳細</h1>
        </div>
      </header>
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
