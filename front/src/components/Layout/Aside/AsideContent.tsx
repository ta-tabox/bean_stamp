import type { FC } from 'react'
import { memo } from 'react'

import { UserAsideContent } from '@/components/Layout/Aside/UserAsideContent'

export const AsideContent: FC = memo(() => (
  <aside className="h-full w-full border-l border-gray-200">
    <div className="h-screen overflow-y-scroll overflow-x-hidden sticky top-0">
      <UserAsideContent />
      {/* TODO ロースターとユーザーで表示を切り替える */}
      {/* <RoasterAsideContent /> */}
    </div>
  </aside>
))
