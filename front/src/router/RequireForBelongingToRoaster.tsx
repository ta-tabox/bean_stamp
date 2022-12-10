import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useCurrentRoaster } from '@/features/roasters'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireForBelongingToRoaster = (props: Props) => {
  const { redirectPath = '/users/home', children } = props
  const { isRoaster, currentRoaster } = useCurrentRoaster()

  if (!isRoaster || !currentRoaster) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
