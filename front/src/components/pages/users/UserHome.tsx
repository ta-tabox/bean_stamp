import type { FC } from 'react'
import { memo } from 'react'

import { useCurrentUser } from '@/hooks/useCurrentUser'
import { PrefectureArray } from '@/lib/mstData/prefecture'

export const UserHome: FC = memo(() => {
  const { currentUser } = useCurrentUser()

  const areaObj = currentUser && PrefectureArray.find(({ id }) => id === parseInt(currentUser.prefectureCode, 10))
  const area = areaObj?.label
  return (
    <>
      <h1>{currentUser && `${currentUser.name}`}のホームページです</h1>
      {area && <p>{`${area}` || null}がエリアです</p>}
    </>
  )
})
