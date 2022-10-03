import type { FC } from 'react'
import { useCallback, useEffect, memo } from 'react'

import { SpinnerLoading } from '@/components/atoms/loading/SpinnerLoading'
import { UserDetailModal } from '@/components/organisms/user/UserDetailModal'
import { UserItem } from '@/components/organisms/user/UserItem'
import { useAllUsers } from '@/hooks/useAllUsers'
import { useCurrentUser } from '@/hooks/useCurrentUser'
import { useModal } from '@/hooks/useModal'
import { useSelectUser } from '@/hooks/useSelectUser'

export const UserManagement: FC = memo(() => {
  const { getUsers, users, loading } = useAllUsers()
  const { selectedUser, onSelectUser } = useSelectUser()
  const { isOpen, onOpen, onClose } = useModal()
  const { currentUser } = useCurrentUser()

  useEffect(() => getUsers(), [])

  const onClickUser = useCallback(
    (id: number) => {
      onSelectUser({ id, users, onOpen })
    },
    [users, onSelectUser, onOpen]
  )

  // タイトル フォロー
  return (
    <section className="card mt-4 mb-20 py-4 text-gray-600">
      {!loading && (
        <ol>
          {users.map((user) => (
            <li key={user.id}>
              <UserItem
                id={user.id}
                userName={user.name}
                address={user.address.city}
                imageUrl="https://source.unsplash.com/random"
                onClick={onClickUser}
              />
            </li>
          ))}
        </ol>
      )}
      {loading && (
        <div className="flex justify-center">
          <SpinnerLoading />
        </div>
      )}
      <UserDetailModal isOpen={isOpen} onClose={onClose} user={selectedUser} isAdmin={currentUser?.isAdmin} />
    </section>
  )
})
