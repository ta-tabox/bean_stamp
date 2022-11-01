import type { FC } from 'react'
import { memo } from 'react'

export const UserBottomNav: FC = memo(() => (
  <>
    {/* ユーザー用 */}
    {/* User Homeリンク */}
    <div className="mobile-nav-item">
      <svg className="w-8 h-8">
        <use xlinkHref="#home-solid" />
      </svg>
    </div>
    {/* Searchリンク */}
    <div className="mobile-nav-item">
      <svg className="w-8 h-8">
        <use xlinkHref="#search-solid" />
      </svg>
    </div>
    {/* Wantsリンク */}
    <div className="mobile-nav-item">
      <svg className="w-8 h-8">
        <use xlinkHref="#shopping-bag-solid" />
      </svg>
    </div>
    {/* お気に入りリンク */}
    <div className="mobile-nav-item">
      <svg className="w-8 h-8">
        <use xlinkHref="#heart-solid" />
      </svg>
    </div>
  </>
))
