import type { FC } from 'react'
import { memo } from 'react'

import { Home } from '@/components/pages/common/Home'
import { useLoginUser } from '@/hooks/useLoginUser'

export const UserHome: FC = memo(() => {
  const { loginUser } = useLoginUser()
  if (loginUser) {
    return <h1>{`${loginUser.name}`}のホームページです</h1>
  }
  return <Home /> // loginUserがnullの場合のハンドリング レンダリング前にnullチェックのようなことができないのか？
})
