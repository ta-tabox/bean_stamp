import type { Dispatch, FC } from 'react'
import React, { useCallback } from 'react'

import { useAuth } from '@/features/auth'
import { createRoasterRelationship } from '@/features/roasterRelationships/api/createRoasterRelationship'
import { deleteRoasterRelationship } from '@/features/roasterRelationships/api/deleteRoasterRelationship'
import { FollowButton } from '@/features/roasterRelationships/components/molecules/FollowButton'
import { UnFollowButton } from '@/features/roasterRelationships/components/molecules/UnFollowButton'

type Props = {
  roasterId: number
  roasterRelationshipId: number | null
  setRoasterRelationshipId: Dispatch<React.SetStateAction<number | null>>
  followersCount: number
  setFollowersCount: Dispatch<React.SetStateAction<number>>
}

export const FollowUnFollowButton: FC<Props> = (props) => {
  const { roasterId, roasterRelationshipId, setRoasterRelationshipId, setFollowersCount, followersCount } = props
  const { authHeaders } = useAuth()

  const onClickFollow = () => {
    createRoasterRelationship({ headers: authHeaders, roasterId })
      .then((response) => {
        setRoasterRelationshipId(response.data.roasterRelationship.id)
        setFollowersCount(followersCount + 1)
      })
      .catch((error) => {
        console.log(error)
      })
  }

  const onClickUnFollow = useCallback(() => {
    if (roasterRelationshipId) {
      deleteRoasterRelationship({ headers: authHeaders, id: roasterRelationshipId.toString() })
        .then(() => {
          setRoasterRelationshipId(null)
          setFollowersCount(followersCount - 1)
        })
        .catch((error) => {
          console.log(error)
        })
    }
  }, [roasterRelationshipId, followersCount])

  return roasterRelationshipId ? <UnFollowButton onClick={onClickUnFollow} /> : <FollowButton onClick={onClickFollow} />
}
