import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useSignedInUser } from '@/features/auth'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireForNotBelongingToRoaster = (props: Props) => {
  const { redirectPath = '/users/home', children } = props
  const { isBelongingToRoaster } = useSignedInUser()

  if (isBelongingToRoaster) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
