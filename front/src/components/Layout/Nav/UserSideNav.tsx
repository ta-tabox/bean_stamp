import type { FC } from 'react'
import { memo } from 'react'

import { SideNavLink } from '@/components/Elements/Link'
import { useAuth } from '@/features/auth'

// ユーザー用
export const UserSideNav: FC = memo(() => {
  const { signOut, user } = useAuth()

  const handleClickSignOut = () => {
    signOut()
  }

  if (typeof user === null) {
    return null
  }

  return (
    <ul className="flex flex-col">
      {/* ユーザーホームリンク */}
      <li className="mb-2">
        <SideNavLink title="Home" to="/users/home">
          <svg className="h-8 w-8">
            <use xlinkHref="#home" />
          </svg>
        </SideNavLink>
      </li>
      {/* マイページリンク */}
      <li className="mb-2">
        <SideNavLink title="User" to={user ? `/users/${user.id}` : '#'}>
          <svg className="h-8 w-8">
            <use xlinkHref="#user" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO フォローリンク */}
      <li className="mb-2">
        <SideNavLink title="Follow" to={user ? `/users/${user.id}/following` : '#'}>
          <svg className="h-8 w-8">
            <use xlinkHref="#star" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO ウォンツリンク */}
      <li className="mb-2">
        <SideNavLink title="Wants" to="/wants">
          <svg className="h-8 w-8">
            <use xlinkHref="#shopping-bag" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO お気に入りリンク */}
      <li className="mb-2">
        <SideNavLink title="Likes" to="/likes">
          <svg className="h-8 w-8">
            <use xlinkHref="#heart" />
          </svg>
        </SideNavLink>
      </li>
      {/* TODO 検索リンク */}
      <li className="mb-2">
        <SideNavLink title="Search" to="/search">
          <svg className="h-8 w-8">
            <use xlinkHref="#search" />
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
        <button type="button" onClick={handleClickSignOut}>
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
