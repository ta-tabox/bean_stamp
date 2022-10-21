import { useCallback, useState } from 'react'

import type { User } from '@/features/users/types'

type Props = {
  id: number
  users: Array<User>
  onOpen: () => void
}

// ユーザーを検索して、そのユーザー情報をモーダルとして表示する
export const useSelectUser = () => {
  const [selectedUser, setSelectedUser] = useState<User | null>(null)
  const onSelectUser = useCallback((props: Props) => {
    const { id, users, onOpen } = props
    const targetUser = users.find((user) => user.id === id)
    setSelectedUser(targetUser ?? null)
    onOpen() // モーダルのisOpenをtrueにする
  }, [])
  return { onSelectUser, selectedUser }
}
