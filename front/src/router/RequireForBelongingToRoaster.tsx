import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useSignedInUser } from '@/features/auth'
import { useCurrentRoaster } from '@/features/roasters'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireForBelongingToRoaster = (props: Props) => {
  const { redirectPath = '/users/home', children } = props
  const { isBelongingToRoaster } = useSignedInUser()
  const { isRoaster } = useCurrentRoaster()

  if (!isRoaster || !isBelongingToRoaster) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
