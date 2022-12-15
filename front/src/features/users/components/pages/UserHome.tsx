import type { FC } from 'react'
import { useEffect, memo } from 'react'

import { Head } from '@/components/Head'
import { useLoadUser } from '@/features/auth'
import { useSignedInUser } from '@/features/auth/hooks/useSignedInUser'
import { translatePrefectureCodeToName } from '@/utils/prefecture'

export const UserHome: FC = memo(() => {
  const { signedInUser } = useSignedInUser()
  const { loadUser } = useLoadUser()

  // NOTE サインイン直後のユーザー＆ロースター情報の更新はここでOKか？
  useEffect(() => {
    void loadUser()
  }, [])

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
