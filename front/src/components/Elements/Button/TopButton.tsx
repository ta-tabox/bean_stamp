import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { useAuth } from '@/features/auth'

export const TopButton: FC = memo(() => {
  const navigate = useNavigate()
  const { isSignedIn } = useAuth()
  const onClickHome = () => {
    if (isSignedIn) {
      navigate('/users/home')
    } else {
      navigate('/')
    }
  }
  return (
    <button type="button" onClick={onClickHome}>
      <h1 className="logo-font md:text-xl h-full px-2 text-gray-900">Bean Stamp</h1>
    </button>
  )
})
