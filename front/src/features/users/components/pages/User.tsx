import type { FC } from 'react'
import { useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'

import { ContentHeader } from '@/components/Elements/Header'
import { ContentHeaderTitle } from '@/components/Elements/Header/ContentHeaderTitle'
import { Spinner } from '@/components/Elements/Spinner'
import { UserCard } from '@/features/users/components/organisms/UserCard'
import { useGetUser } from '@/features/users/hooks/useGetUser'

export const User: FC = () => {
  const urlParams = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { user, getUser, loading } = useGetUser()

  useEffect(() => {
    // urlParams.idが数値かどうか評価
    if (urlParams.id && !Number.isNaN(parseInt(urlParams.id, 10))) {
      getUser(urlParams.id)
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
