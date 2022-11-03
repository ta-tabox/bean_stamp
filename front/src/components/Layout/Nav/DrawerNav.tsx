import type { Dispatch, FC } from 'react'

import Drawer from 'react-modern-drawer'
import { useRecoilValue } from 'recoil'

import 'react-modern-drawer/dist/index.css'

import { DrawerNavLink } from '@/components/Elements/Link'
import { BottomNavItem } from '@/components/Layout/Nav/BottomNavItem'
import { useAuth } from '@/features/auth'
import { isRoasterState } from '@/stores/isRoaster'

type Props = {
  isOpen: boolean
  setIsOpen: Dispatch<React.SetStateAction<boolean>>
}

export const DrawerNav: FC<Props> = (props) => {
  const { isOpen, setIsOpen } = props
  const isRoaster = useRecoilValue(isRoasterState)

  const { signOut } = useAuth()
  const toggleDrawer = () => {
    setIsOpen((prevState) => !prevState)
  }

  const handleClickSignOut = () => {
    signOut()
  }

  return (
    <Drawer open={isOpen} onClose={toggleDrawer} direction="right" size={150}>
      <div className="absolute bottom-0 inset-x-0">
        <ul className="flex flex-col w-full text-left ml-auto">
          {/* TODO リンクの作成 */}
          {isRoaster ? (
            <>
              {/* ロースター用 */}
              <li>
                <DrawerNavLink to="/roaster/show" title="マイロースター" />
              </li>
            </>
          ) : (
            <>
              {/* ユーザー用 */}
              <li className="">
                <DrawerNavLink to="/home" title="マイページ" />
              </li>
              <li>
                <DrawerNavLink to="/follow" title="フォロー" />
              </li>
            </>
          )}
          <li>
            <DrawerNavLink to="/help" title="ヘルプ" />
          </li>
          <li>
            <button type="button" onClick={handleClickSignOut} className="w-full text-left">
              <DrawerNavLink to="#" title="ログアウト" />
            </button>
          </li>
        </ul>
        <div className="h-14 pr-8 flex items-center justify-end">
          <button type="button" onClick={toggleDrawer}>
            <BottomNavItem>
              <svg id="drawer-open-btn" className="w-8 h-8">
                <use xlinkHref="#menu" />
              </svg>
            </BottomNavItem>
          </button>
        </div>
      </div>
    </Drawer>
  )
}
