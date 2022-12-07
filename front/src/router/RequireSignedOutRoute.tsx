import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useSignedInUser } from '@/features/auth'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireSignedOutRoute = (props: Props) => {
  const { redirectPath = '/users/home', children } = props
  const { isSignedIn } = useSignedInUser()

  if (isSignedIn) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
