import type { FC } from 'react'
import { memo } from 'react'

import { SideNavLink } from '@/components/Elements/Link'
import { useAuth } from '@/features/auth'

export const RoasterSideNav: FC = memo(() => {
  const { signOut } = useAuth()

  const handleClickSingout = () => {
    signOut()
  }

  return (
    <ul className="flex flex-col">
      {/* ロースター用 */}
      {/* TODO ロースターホームリンク */}
      <li className="mb-2">
        <SideNavLink title="Home" to="/roaster/home">
          <svg className="h-8 w-8">
            <use xlinkHref="#home" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO ロースターページリンク */}
      <li className="mb-2">
        <SideNavLink title="Roaster" to="/roaster/show">
          <svg className="h-8 w-8">
            <use xlinkHref="#coffee-cup" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO ビーンズリンク */}
      <li className="mb-2">
        <SideNavLink title="Beans" to="/beans">
          <svg className="h-8 w-8 transform -rotate-45">
            <use xlinkHref="#coffee-bean" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO オファーリンク */}
      <li className="mb-2">
        <SideNavLink title="Offers" to="/offers">
          <svg className="h-8 w-8">
            <use xlinkHref="#clipboard" />
          </svg>
        </SideNavLink>
      </li>
      {/* 共通 */}
      {/* ヘルプリンク */}
      <li className="mb-2">
        <SideNavLink title="Help" to="/help">
          <svg className="h-8 w-8">
            <use xlinkHref="#question-mark-circle" />
          </svg>
        </SideNavLink>
      </li>
      {/* ログアウトリンク */}
      <li className="mb-2">
        <button type="button" onClick={handleClickSingout}>
          <SideNavLink title="SignOut" to="#">
            <svg className="h-8 w-8">
              <use xlinkHref="#logout" />
            </svg>
          </SideNavLink>
        </button>
      </li>
    </ul>
  )
})
