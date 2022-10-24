import type { FC } from 'react'
import { memo } from 'react'

import { Head } from '@/components/Head'
import { useAuth } from '@/features/auth'
import { PrefectureArray } from '@/utils/prefecture'

export const UserHome: FC = memo(() => {
  const { user } = useAuth()

  const areaObj = user && PrefectureArray.find(({ id }) => id === parseInt(user.prefectureCode, 10))
  const area = areaObj?.label
  return (
    <>
      <Head title="ホーム" />
      <h1>{user && `${user.name}`}のホームページです</h1>
      {area && <p>{`${area}` || null}がエリアです</p>}
    </>
  )
})