import type { FC } from 'react'
import { memo } from 'react'

import { Home } from '@/components/pages/common/Home'
import { useCurrentUser } from '@/hooks/useCurrentUser'
import { PrefectureArray } from '@/lib/mstData/prefecture'

export const UserHome: FC = memo(() => {
  const { currentUser } = useCurrentUser()
  if (currentUser) {
    const areaObj = PrefectureArray.find(({ id }) => id === parseInt(currentUser.prefectureCode, 10))
    const area = areaObj?.label
    return (
      <>
        <h1>{`${currentUser.name}`}のホームページです</h1>
        {area && <p>{`${area}` || null}がエリアです</p>}
      </>
    )
  }
  return <Home /> // loginUserがnullの場合のハンドリング レンダリング前にnullチェックのようなことができないのか？
})
