import type { FC } from 'react'
import { memo } from 'react'

import { useRecoilValue } from 'recoil'

import { RoasterAsideContent } from '@/components/Layout/Aside/RoasterAsideContent'
import { UserAsideContent } from '@/components/Layout/Aside/UserAsideContent'
import { isRoasterState } from '@/stores/isRoaster'

export const AsideContent: FC = memo(() => {
  const isRoaster = useRecoilValue(isRoasterState)

  return (
    <aside className="h-full w-full border-l border-gray-200">
      <div className="h-screen overflow-y-scroll overflow-x-hidden sticky top-0">
        {isRoaster ? <RoasterAsideContent /> : <UserAsideContent />}
      </div>
    </aside>
  )
})
