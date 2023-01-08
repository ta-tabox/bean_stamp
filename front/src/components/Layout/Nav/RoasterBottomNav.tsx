import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

import { BottomNavItem } from '@/components/Layout/Nav/BottomNavItem'
import type { Roaster } from '@/features/roasters'

type Props = {
  roaster: Roaster
}

export const RoasterBottomNav: FC<Props> = memo((props) => {
  const { roaster } = props
  return (
    <>
      {/* ロースター用 */}
      {/* Roaster Homeリンク */}
      <Link to="/roasters/home">
        <BottomNavItem>
          <svg className="w-8 h-8">
            <use xlinkHref="#home-solid" />
          </svg>
        </BottomNavItem>
      </Link>
      {/* ロースターページリンク */}
      <Link to={`/roasters/${roaster.id}`}>
        <BottomNavItem>
          <i className="fa-solid fa-mug-saucer fa-xl" />
        </BottomNavItem>
      </Link>
      {/* TODO Offersリンク */}
      <Link to="/roaster/show">
        <BottomNavItem>
          <svg className="w-8 h-8">
            <use xlinkHref="#clipboard-solid" />
          </svg>
        </BottomNavItem>
      </Link>
      {/* ビーンズリンク */}
      <Link to="/beans">
        <BottomNavItem>
          <svg className="h-8 w-8 transform -rotate-45">
            <use xlinkHref="#coffee-bean-solid" />
          </svg>
        </BottomNavItem>
      </Link>
    </>
  )
})
