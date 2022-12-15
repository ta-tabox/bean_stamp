import type { FC } from 'react'

import pluralize from 'pluralize'

import { Link } from '@/components/Elements/Link'
import type { Roaster } from '@/features/roasters/types'

type Props = {
  roaster: Roaster
}

export const LinkToRoasterFollower: FC<Props> = (props) => {
  const { roaster } = props

  return <Link to={`/roasters/${roaster.id}/follower`}>{pluralize('follower', roaster.followersCount, true)}</Link>
}
