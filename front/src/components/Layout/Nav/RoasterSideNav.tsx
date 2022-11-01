import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

import { SideNavLink } from '@/components/Elements/Link/SideNavLink'
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
        <Link to="/roaster/home">
          <SideNavLink title="Home">
            <svg className="h-8 w-8">
              <use xlinkHref="#home" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* TODO ロースターページリンク */}
      <li className="mb-2">
        <Link to="/roaster/show">
          <SideNavLink title="Roaster">
            <svg className="h-8 w-8">
              <use xlinkHref="#coffee-cup" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* TODO ビーンズリンク */}
      <li className="mb-2">
        <Link to="/bean">
          <SideNavLink title="Beans">
            <svg className="h-8 w-8 transform -rotate-45">
              <use xlinkHref="#coffee-bean" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* TODO オファーリンク */}
      <li className="mb-2">
        <Link to="/bean">
          <SideNavLink title="Offers">
            <svg className="h-8 w-8">
              <use xlinkHref="#clipboard" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* 共通 */}
      {/* ヘルプリンク */}
      <li className="mb-2">
        <Link to="/help">
          <SideNavLink title="Help">
            <svg className="h-8 w-8">
              <use xlinkHref="#question-mark-circle" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* ログアウトリンク */}
      <li className="mb-2">
        <button type="button" onClick={handleClickSingout}>
          <SideNavLink title="SignOut">
            <svg className="h-8 w-8">
              <use xlinkHref="#logout" />
            </svg>
          </SideNavLink>
        </button>
      </li>
    </ul>
  )
})
