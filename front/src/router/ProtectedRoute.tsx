import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useAuth } from '@/features/auth'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const ProtectedRoute = (props: Props) => {
  const { redirectPath = '/auth/signin', children } = props
  const { isSignedIn } = useAuth()
  if (!isSignedIn) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
