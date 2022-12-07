import type { FC } from 'react'
import { memo } from 'react'

import { Head } from '@/components/Head'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { PrefectureArray } from '@/utils/prefecture'

export const RoasterHome: FC = memo(() => {
  const { signedInUser } = useSignedInUser()

  const areaObj = signedInUser && PrefectureArray.find(({ id }) => id === parseInt(signedInUser.prefectureCode, 10))
  const area = areaObj?.label
  return (
    <>
      <Head title="ホーム" />
      <h1>{signedInUser && `${signedInUser.name}`}のホームページです</h1>
      {area && <p>{`${area}` || null}がエリアです</p>}
      <div className="h-64  bg-green-300" />
      <div className="h-64  bg-pink-300" />
      <div className="h-64  bg-green-300" />
      <div className="h-64  bg-pink-300" />
      <div className="h-64  bg-green-300" />
      <div className="h-64  bg-pink-300" />
      <div className="h-64  bg-green-300" />
      <div className="h-64  bg-pink-300" />
      <div className="h-64  bg-green-300" />
    </>
  )
})
