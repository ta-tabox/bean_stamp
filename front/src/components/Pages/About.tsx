import type { FC } from 'react'
import { memo } from 'react'

import { Head } from '@/components/Head'

export const About: FC = memo(() => (
  <>
    <Head title="About" />
    <h1>Aboutページ</h1>
  </>
))
