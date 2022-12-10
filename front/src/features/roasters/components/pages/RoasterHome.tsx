import type { FC } from 'react'
import { memo } from 'react'

import { Head } from '@/components/Head'
import { useCurrentRoaster } from '@/features/roasters/hooks/useCurrentRoaster'
import { PrefectureArray } from '@/utils/prefecture'

export const RoasterHome: FC = memo(() => {
  const { currentRoaster } = useCurrentRoaster()

  const areaObj = currentRoaster && PrefectureArray.find(({ id }) => id === parseInt(currentRoaster.prefectureCode, 10))
  const area = areaObj?.label
  return (
    <>
      <Head title="ホーム" />
      {console.log('RoasterHome')}
      <h1>{currentRoaster && `${currentRoaster.name}`}のホームページです</h1>
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
