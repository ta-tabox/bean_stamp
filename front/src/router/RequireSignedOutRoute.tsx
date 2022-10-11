import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useCurrentUser } from '@/hooks/useCurrentUser'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireSignedOutRoute = (props: Props) => {
  const { redirectPath = '/user/home', children } = props
  const { isSignedIn } = useCurrentUser()

  if (isSignedIn) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
