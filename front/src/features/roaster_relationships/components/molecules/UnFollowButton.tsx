import type { FC } from 'react'

import { SecondaryButton } from '@/components/Elements/Button'
import { useAuth } from '@/features/auth'
import { createRoasterRelationship } from '@/features/roaster_relationships/api/createRoasterRelationship'

type Props = {
  roasterId: number
}

export const UnFollowButton: FC<Props> = (props) => {
  const { roasterId } = props
  const { authHeaders } = useAuth()

  const onClick = () => {
    createRoasterRelationship({ headers: authHeaders, roasterId })
      .then((response) => {
        console.log(response.data)
      })
      .catch((error) => {
        console.log(error)
      })
  }

  return <SecondaryButton onClick={onClick}>UnFollow</SecondaryButton>
}
