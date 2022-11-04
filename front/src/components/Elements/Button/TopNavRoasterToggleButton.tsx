import type { FC } from 'react'
import { memo } from 'react'

import { useRecoilState } from 'recoil'

import { isRoasterState } from '@/stores/isRoaster'

export const TopNavRoasterToggleButton: FC = memo(() => {
  const [isRoaster, setIsRoaster] = useRecoilState(isRoasterState)

  const handleClick = () => {
    setIsRoaster(!isRoaster)
  }
  return (
    <div className="relative">
      <svg className="h-4 w-4 text-white absolute top-2 left-2">
        <use xlinkHref="#switch-horizontal" />
      </svg>
      <button
        type="submit"
        className="w-24 pl-8 pr-2 py-1 border rounded cursor-pointer block text-center text-sm font-medium bg-indigo-500 border-indigo-600 text-white hover:bg-indigo-600 active:bg-indigo-700"
        onClick={handleClick}
      >
        {isRoaster ? 'User' : 'Roaster'}
      </button>
    </div>
  )
})
