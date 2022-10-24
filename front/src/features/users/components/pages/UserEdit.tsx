import type { FC } from 'react'
import { memo } from 'react'

import { Head } from '@/components/Head'

export const UserEdit: FC = memo(() => (
  <>
    <Head title="ユーザー編集" />
    <h1>ユーザー編集ページです</h1>
  </>
))
