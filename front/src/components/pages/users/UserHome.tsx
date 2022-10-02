import type { FC } from 'react'
import { memo } from 'react'

import { Home } from '@/components/pages/common/Home'
import { useLoginUser } from '@/hooks/useLoginUser'
import { PrefectureArray } from '@/lib/mstData/prefecture'

export const UserHome: FC = memo(() => {
  const { loginUser } = useLoginUser()
  if (loginUser) {
    const areaObj = PrefectureArray.find(({ id }) => id === parseInt(loginUser.prefectureCode, 10))
    const area = areaObj?.label
    return (
      <>
        <h1>{`${loginUser.name}`}のホームページです</h1>
        {area && <p>{`${area}` || null}がエリアです</p>}
      </>
    )
  }
  return <Home /> // loginUserがnullの場合のハンドリング レンダリング前にnullチェックのようなことができないのか？
})
