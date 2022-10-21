import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { useAuth } from '@/features/auth'

export const TopButton: FC = memo(() => {
  const navigate = useNavigate()
  const { isSignedIn } = useAuth()
  const onClickHome = () => {
    if (isSignedIn) {
      navigate('/user/home')
    } else {
      navigate('/')
    }
  }
  return (
    <button type="button" onClick={onClickHome} className="h-full pl-2 md:pl-12 logo-font md:text-xl">
      <h1 className="h-full px-2 flex justify-center items-center text-gray-900">Bean Stamp</h1>
    </button>
  )
})
