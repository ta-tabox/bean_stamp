import type { FC } from 'react'

import pluralize from 'pluralize'

import { Link } from '@/components/Elements/Link'

type Props = {
  roasterId: number
  followersCount: number
}

export const LinkToRoasterFollower: FC<Props> = (props) => {
  const { roasterId, followersCount } = props

  return <Link to={`/roasters/${roasterId}/follower`}>{pluralize('follower', followersCount, true)}</Link>
}
