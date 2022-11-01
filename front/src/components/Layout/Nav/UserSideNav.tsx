import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

import { SideNavLink } from '@/components/Elements/Link/SideNavLink'
import { useAuth } from '@/features/auth'

// ユーザー用
export const UserSideNav: FC = memo(() => {
  const { signOut } = useAuth()

  const handleClickSingout = () => {
    signOut()
  }

  return (
    <ul className="flex flex-col">
      {/* ユーザーホームリンク */}
      <li className="mb-2">
        <Link to="/user/home">
          <SideNavLink title="Home">
            <svg className="h-8 w-8">
              <use xlinkHref="#home" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* マイページリンク */}
      <li className="mb-2">
        {/* TODO マイページリンク */}
        <Link to="/user">
          <SideNavLink title="User">
            <svg className="h-8 w-8">
              <use xlinkHref="#user" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* フォローリンク */}
      <li className="mb-2">
        {/* TODO フォローリンク */}
        <Link to="/user">
          <SideNavLink title="Follow">
            <svg className="h-8 w-8">
              <use xlinkHref="#star" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* ウォンツリンク */}
      <li className="mb-2">
        {/* TODO ウォンツリンク */}
        <Link to="/user">
          <SideNavLink title="Wants">
            <svg className="h-8 w-8">
              <use xlinkHref="#shopping-bag" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* お気に入りリンク */}
      <li className="mb-2">
        {/* TODO お気に入りリンク */}
        <Link to="/user">
          <SideNavLink title="Likes">
            <svg className="h-8 w-8">
              <use xlinkHref="#heart" />
            </svg>
          </SideNavLink>
        </Link>
      </li>
      {/* 検索リンク */}
      <li className="mb-2">
        {/* TODO 検索リンク */}
        <Link to="/user">
          <SideNavLink title="Search">
            <svg className="h-8 w-8">
              <use xlinkHref="#search" />
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
