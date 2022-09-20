import type { FC } from 'react'
import { memo } from 'react'

import { execTest } from '@/lib/api/test'

export const Home: FC = memo(() => {
  const onClickTest = () => {
    execTest() // eslint-disable-line @typescript-eslint/no-floating-promises
  }

  return (
    <>
      <h1 className="text-3xl font-bold underline text-red-600">Hello world!</h1>
      <button type="button" onClick={onClickTest}>
        テスト
      </button>
    </>
  )
})
