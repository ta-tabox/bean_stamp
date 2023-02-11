import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

import { BottomNavItem } from '@/components/Layout/Nav/BottomNavItem'

export const UserBottomNav: FC = memo(() => (
  <>
    {/* ユーザー用 */}
    {/* User Homeリンク */}
    <Link to="/users/home">
      <BottomNavItem>
        <svg className="w-8 h-8">
          <use xlinkHref="#home-solid" />
        </svg>
      </BottomNavItem>
    </Link>

    {/* TODO Searchリンク */}
    <Link to="/search">
      <BottomNavItem>
        <svg className="w-8 h-8">
          <use xlinkHref="#search-solid" />
        </svg>
      </BottomNavItem>
    </Link>

    {/* Wantsリンク */}
    <Link to="/wants">
      <BottomNavItem>
        <svg className="w-8 h-8">
          <use xlinkHref="#shopping-bag-solid" />
        </svg>
      </BottomNavItem>
    </Link>

    {/* お気に入りリンク */}
    <Link to="/likes">
      <BottomNavItem>
        <svg className="w-8 h-8">
          <use xlinkHref="#heart-solid" />
        </svg>
      </BottomNavItem>
    </Link>
  </>
))
