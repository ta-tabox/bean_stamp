import type { FC } from 'react'
import { Link } from 'react-router-dom'

import { Card, CardContainer } from '@/components/Elements/Card'
import { UserImage } from '@/features/users/components/molecules/UserImage'
import type { User } from '@/features/users/types'
import { translatePrefectureCodeToName } from '@/utils/prefecture'

type Props = {
  user: User
}

export const UserCard: FC<Props> = (props) => {
  const { user } = props
  return (
    <Card>
      <CardContainer>
        <div className="items-center flex flex-col lg:flex-row">
          <div className="lg:w-1/2 lg:mx-4 text-center lg:text-left">
            <Link to={user.id ? `/users/${user.id}` : '#'}>
              <div className="text-2xl font-medium text-gray-800 mx-auto">{user.name}</div>
            </Link>
            <div className="mx-auto">{/* <%= link_to_edit_user(user) %> */}</div>
            <div className="mt-4 text-gray-500 lg:max-w-md">
              <div>@ {user.prefectureCode ? translatePrefectureCodeToName(user.prefectureCode) : null}</div>
              <p className="mt-4">{user.describe}</p>
            </div>
          </div>
          <div className="mt-8 lg:mt-0 lg:w-1/2">
            <div className="flex items-center justify-center lg:justify-end">
              <div className="max-w-lg">
                <UserImage user={user} />
              </div>
            </div>
          </div>
        </div>
      </CardContainer>
    </Card>
  )
}
