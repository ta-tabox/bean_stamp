import type { FC } from 'react'
import { memo } from 'react'

import { TopButton } from '@/components/Elements/Button'
import { UserSideNav } from '@/components/Layout/Nav/UserSideNav'
import { UserSideToggle } from '@/components/Layout/Nav/UserSideToggle'

export const SideNav: FC = memo(() => (
  <nav className="h-full w-28">
    <div className="min-h-screen w-full sticky flex flex-col justify-between items-center top-0 z-50 border-r border-gray-200">
      {/* TOPアイコン */}
      <div className="mx-4 mt-12 pb-8">
        <TopButton />
      </div>
      <div className="w-12 mx-auto">
        <hr className="border-gray-200" />
      </div>
      {/* ナビアイコン */}
      <div className="ml-14">
        {/* TODO isRoasterフラグで切り替える */}
        <UserSideNav />
        {/* <RoasterSideNav /> */}
      </div>
      <div className="w-12 mx-auto">
        <hr className="border-gray-200" />
      </div>
      {/* 切り替えアイコン */}
      <div className="mb-8">
        {/* TODO ロースターと切り替える, リンクは画像を表示する */}
        <UserSideToggle />
        <svg className="h-6 w-6 mx-auto text-gray-600 mt-2">
          <use xlinkHref="#switch-horizontal" />
        </svg>
      </div>
    </div>
  </nav>
))
