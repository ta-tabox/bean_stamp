import type { FC } from 'react'
import { memo } from 'react'

import { useRecoilValue } from 'recoil'

import { SideNavRoasterToggleButton, TopButton } from '@/components/Elements/Button'
import { RoasterSideNav } from '@/components/Layout/Nav/RoasterSideNav'
import { UserSideNav } from '@/components/Layout/Nav/UserSideNav'
import { useAuth } from '@/features/auth'
import { isRoasterState } from '@/stores/isRoaster'

export const SideNav: FC = memo(() => {
  const { signedInUser } = useAuth()
  const isRoaster = useRecoilValue(isRoasterState)

  // TODO roasterの定義とfitchメソッドの作成 toggle buttonにpropsにとして渡す

  return (
    <nav className="h-full w-28">
      {signedInUser && (
        <div className="min-h-screen w-full sticky flex flex-col justify-between items-center top-0 border-r border-gray-200">
          {/* TOPアイコン */}
          <div className="mx-4 mt-12 pb-8">
            <TopButton />
          </div>
          <div className="w-12 mx-auto">
            <hr className="border-gray-200" />
          </div>
          {/* ナビアイコン */}
          <div className="ml-14">{isRoaster ? <RoasterSideNav /> : <UserSideNav user={signedInUser} />}</div>
          <div className="w-12 mx-auto">
            <hr className="border-gray-200" />
          </div>
          {/* Roaster 切り替え */}
          <div className="mb-8">
            <SideNavRoasterToggleButton user={signedInUser} />
          </div>
        </div>
      )}
    </nav>
  )
})
