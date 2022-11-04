import type { FC } from 'react'
import { useState } from 'react'

import { useRecoilValue } from 'recoil'

import { Hamburger } from '@/components/Elements/Hamburger'
import { DrawerNav } from '@/components/Layout/Nav/DrawerNav'
import { RoasterBottomNav } from '@/components/Layout/Nav/RoasterBottomNav'
import { UserBottomNav } from '@/components/Layout/Nav/UserBottomNav'
import { isRoasterState } from '@/stores/isRoaster'

export const BottomNav: FC = () => {
  const isRoaster = useRecoilValue(isRoasterState)

  const [isOpen, setIsOpen] = useState(false)

  const toggleDrawer = () => {
    setIsOpen((prevState) => !prevState)
  }

  return (
    <nav className="h-14 fixed bottom-0 inset-x-0 z-50 border-t border-bray-200 bg-gray-100">
      <div className="h-full px-8 flex items-center justify-between">
        {isRoaster ? <RoasterBottomNav /> : <UserBottomNav />}
        <Hamburger toggled={isOpen} toggle={toggleDrawer} />
      </div>
      <DrawerNav isOpen={isOpen} setIsOpen={setIsOpen} />
    </nav>
  )
}
