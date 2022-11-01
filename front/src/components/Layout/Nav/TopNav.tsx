import type { FC } from 'react'
import { memo } from 'react'

import { RoasterToggleButton, TopButton } from '@/components/Elements/Button'

export const TopNav: FC = memo(() => (
  <section className="h-14 fixed top-0 inset-x-0 z-40 border-b border-gray-200 bg-gray-100">
    <div className="h-full flex items-center justify-between">
      {/* TOPアイコン */}
      <div className="pl-4">
        <TopButton />
      </div>
      {/* 切り替えアイコン */}
      <div className="mr-4">
        <RoasterToggleButton />
      </div>
    </div>
  </section>
))
