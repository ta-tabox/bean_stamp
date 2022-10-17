import type { FC } from 'react'
import { useCallback, useEffect, memo } from 'react'

import { Spinner } from '@/components/Elements/Spinner'
import { useCurrentUser } from '@/features/auth'
import { UserDetailModal } from '@/features/users/components/organisms/UserDetailModal'
import { UserItem } from '@/features/users/components/organisms/UserItem'
import { useAllUsers } from '@/features/users/hooks/useAllUsers'
import { useSelectUser } from '@/features/users/hooks/useSelectUser'
import { useModal } from '@/hooks/useModal'
import { translatePrefectureCodeToName } from '@/utils/prefecture'

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
                area={translatePrefectureCodeToName(user.prefectureCode)}
                imageUrl="https://source.unsplash.com/random"
                onClick={onClickUser}
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
      <UserDetailModal isOpen={isOpen} onClose={onClose} user={selectedUser} isAdmin={currentUser?.admin} />
    </section>
  )
})
