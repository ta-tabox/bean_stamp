import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

export const Page404: FC = memo(() => (
  <>
    <h1>ページが見つかりません</h1>
    <Link to="/">Homeへ戻る</Link>
  </>
))
