import type { ReactElement } from 'react'
import { Navigate, Outlet } from 'react-router-dom'

import { useCurrentRoaster } from '@/features/roasters'

type Props = {
  redirectPath?: string
  children?: ReactElement
}

export const RequireNotIsRoaster = (props: Props) => {
  const { redirectPath = '/roasters/home', children } = props

  const { isRoaster } = useCurrentRoaster()

  if (isRoaster) {
    return <Navigate to={redirectPath} replace />
  }

  if (children) {
    return children
  }
  return <Outlet />
}
