import type { FC } from 'react'
import { useEffect, memo } from 'react'

import { SpinnerLoading } from '@/components/atoms/loading/SpinnerLoading'
import { UserItem } from '@/components/organisms/user/UserItem'
import { useAllUsers } from '@/hooks/useAllUsers'

export const UserManagement: FC = memo(() => {
  const { getUsers, users, loading } = useAllUsers()

  useEffect(() => getUsers(), [])

  // タイトル フォロー
  return (
    <section className="card mt-4 mb-20 py-4 text-gray-600">
      {!loading && (
        <ol>
          {users.map((user) => (
            <UserItem
              key={user.id}
              userName={user.name}
              address={user.address.city}
              imageUrl="https://source.unsplash.com/random"
            />
          ))}
        </ol>
      )}
      {loading && (
        <div className="flex justify-center">
          <SpinnerLoading />
        </div>
      )}
    </section>
  )
})
