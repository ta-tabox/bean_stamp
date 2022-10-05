import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useCurrentUser } from '@/hooks/useCurrentUser'
import { useMessage } from '@/hooks/useMessage'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireSignedOutRoute = (props: Props) => {
  const { redirectPath = '/user/home', children } = props
  const { isSignedIn } = useCurrentUser()
  const { showMessage } = useMessage()

  if (isSignedIn) {
    showMessage({
      message: 'すでにログインしています',
      type: 'error',
    })
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
