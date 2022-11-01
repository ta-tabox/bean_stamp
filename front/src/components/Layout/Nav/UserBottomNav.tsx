import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

import { BottomNavItem } from '@/components/Layout/Nav/BottomNavItem'

export const UserBottomNav: FC = memo(() => (
  <>
    {/* ユーザー用 */}
    {/* User Homeリンク */}
    <Link to="/user/home">
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
    {/* TODO Wantsリンク */}
    <Link to="/want">
      <BottomNavItem>
        <svg className="w-8 h-8">
          <use xlinkHref="#shopping-bag-solid" />
        </svg>
      </BottomNavItem>
    </Link>

    {/* TODO お気に入りリンク */}
    <Link to="/link">
      <BottomNavItem>
        <svg className="w-8 h-8">
          <use xlinkHref="#heart-solid" />
        </svg>
      </BottomNavItem>
    </Link>
  </>
))
