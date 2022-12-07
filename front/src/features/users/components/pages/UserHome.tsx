import type { FC } from 'react'
import { memo } from 'react'

import { Head } from '@/components/Head'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { translatePrefectureCodeToName } from '@/utils/prefecture'

export const UserHome: FC = memo(() => {
  const { signedInUser } = useSignedInUser()

  return (
    <>
      <Head title="ホーム" />
      <h1>{signedInUser && `${signedInUser.name}`}のホームページです</h1>
      {signedInUser?.prefectureCode && (
        <p>
          {`${translatePrefectureCodeToName({ prefectureCode: signedInUser?.prefectureCode })}` || null}がエリアです
        </p>
      )}
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
