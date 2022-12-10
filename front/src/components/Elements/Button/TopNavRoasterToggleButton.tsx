import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { useCurrentRoaster } from '@/features/roasters'

export const TopNavRoasterToggleButton: FC = memo(() => {
  const { isRoaster, setIsRoaster } = useCurrentRoaster()
  const navigate = useNavigate()

  const handleClick = () => {
    if (isRoaster) {
      navigate('/users/home')
    } else {
      navigate('/roasters/home')
    }
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
