import type { FC } from 'react'
import { memo } from 'react'

export const RoasterBottomNav: FC = memo(() => (
  <>
    {/* ロースター用 */}
    {/* Roaster Homeリンク */}
    <div className="mobile-nav-item">
      <svg className="w-8 h-8">
        <use xlinkHref="#home-solid" />
      </svg>
    </div>
    {/* ロースターページリンク */}
    <div className="mobile-nav-item">
      <i className="fa-solid fa-mug-saucer fa-xl" />
    </div>
    {/* Offersリンク */}
    <div className="mobile-nav-item">
      <svg className="w-8 h-8">
        <use xlinkHref="#clipboard-solid" />
      </svg>
    </div>
    {/* ビーンズリンク */}
    <div className="mobile-nav-item">
      <svg className="h-8 w-8 transform -rotate-45">
        <use xlinkHref="#coffee-bean-solid" />
      </svg>
    </div>
  </>
))
