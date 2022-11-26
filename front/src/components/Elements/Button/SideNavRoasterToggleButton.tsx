import type { FC } from 'react'
import { memo } from 'react'

import { useRecoilState } from 'recoil'

import { isRoasterState } from '@/stores/isRoaster'

export const SideNavRoasterToggleButton: FC = memo(() => {
  const [isRoaster, setIsRoaster] = useRecoilState(isRoasterState)

  const handleClick = () => {
    setIsRoaster(!isRoaster)
  }

  return (
    <div>
      {/* TODO スタイル整える 感覚的に変更するのがわかるようにする */}
      <button type="submit" onClick={handleClick}>
        {/* TODO リンク先を変更 ユーザー、ロースターイメージを使用する */}
        <img
          src={isRoaster ? 'https://source.unsplash.com/random' : 'https://source.unsplash.com/random'}
          alt=""
          className="object-cover w-20 h-20 rounded-full border-2 border-indigo-500"
        />
      </button>
      <p className="mx-auto text-center font-light">{isRoaster ? 'TO USER' : 'TO ROASTER'}</p>
      <svg className="h-6 w-6 mx-auto text-gray-600 mt-2">
        <use xlinkHref="#switch-horizontal" />
      </svg>
    </div>
  )
})
