import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import type { Roaster } from '@/features/roasters'
import { useCurrentRoaster } from '@/features/roasters'
import defaultRoasterImage from '@/features/roasters/assets/defaultRoaster.png'
import type { User } from '@/features/users'
import defaultUserImage from '@/features/users/assets/defaultUser.png'

type Props = {
  user: User
  roaster: Roaster
}

export const SideNavRoasterToggleButton: FC<Props> = memo((props) => {
  const { user, roaster } = props
  const { isRoaster, setIsRoaster } = useCurrentRoaster()
  const navigate = useNavigate()

  const handleClick = () => {
    if (isRoaster) {
      navigate('/users/home')
    } else {
      navigate('/roasters/home')
    }
    setIsRoaster(!isRoaster)
  }

  const userImageUrl = user.image.url ? `${user.image.url}` : defaultUserImage
  const roasterImageUrl = roaster.image.url ? `${roaster.image.url}` : defaultRoasterImage

  return (
    <div>
      {/* TODO スタイル整える 感覚的に変更するのがわかるようにする */}
      <button type="submit" onClick={handleClick}>
        <img
          src={isRoaster ? userImageUrl : roasterImageUrl}
          alt={`${isRoaster ? user.name : roaster.name}のホームへのリンクの画像`}
          className="object-cover w-20 h-20 rounded-full border-2 border-indigo-500"
        />
      </button>
      <p className="mx-auto text-center font-light">{isRoaster ? 'TO USER' : 'TO ROASTER'}</p>

      <svg className="h-6 w-6 mx-auto text-gray-600 mt-2">
        <use xlinkHref="#switch-horizontal" />
      </svg>
    </div>
  )
})
