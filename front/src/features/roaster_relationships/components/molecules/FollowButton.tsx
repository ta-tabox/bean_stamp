import type { Dispatch, FC } from 'react'

import { PrimaryButton, SecondaryButton } from '@/components/Elements/Button'
import { useAuth } from '@/features/auth'
import { createRoasterRelationship } from '@/features/roaster_relationships/api/createRoasterRelationship'
import { deleteRoasterRelationship } from '@/features/roaster_relationships/api/deleteRoasterRelationship'

type Props = {
  roasterId: number
  roasterRelationshipId: number | null
  setRoasterRelationshipId: Dispatch<React.SetStateAction<number | null>>
}

export const FollowButton: FC<Props> = (props) => {
  const { roasterId, roasterRelationshipId, setRoasterRelationshipId } = props
  const { authHeaders } = useAuth()

  const onClickFollow = () => {
    createRoasterRelationship({ headers: authHeaders, roasterId })
      .then((response) => {
        setRoasterRelationshipId(response.data.roasterRelationship.id)
      })
      .catch((error) => {
        console.log(error)
      })
  }

  const onClickUnFollow = () => {
    if (roasterRelationshipId) {
      deleteRoasterRelationship({ headers: authHeaders, id: roasterRelationshipId.toString() })
        .then(() => {
          setRoasterRelationshipId(null)
        })
        .catch((error) => {
          console.log(error)
        })
    }
  }

  return roasterRelationshipId ? (
    <SecondaryButton onClick={onClickUnFollow}>UnFollow</SecondaryButton>
  ) : (
    <PrimaryButton onClick={onClickFollow}>Follow</PrimaryButton>
  )
}
