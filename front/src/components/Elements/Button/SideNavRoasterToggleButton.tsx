import type { FC } from 'react'

import { useRecoilState } from 'recoil'

import defaultRoasterImage from '@/features/roasters/assets/defaultRoaster.png'
import type { User } from '@/features/users'
import defaultUserImage from '@/features/users/assets/default_user.png'
import { isRoasterState } from '@/stores/isRoaster'

type Props = {
  user: User
}

export const SideNavRoasterToggleButton: FC<Props> = (props) => {
  const { user } = props
  // isRoasterをpropsとして受け取り、memo化する
  // roasterをpropsとして受け取る
  const [isRoaster, setIsRoaster] = useRecoilState(isRoasterState)

  const handleClick = () => {
    setIsRoaster(!isRoaster)
  }

  const userImageUrl = user.image.url ? `${user.image.url}` : defaultUserImage
  const roasterImageUrl = defaultRoasterImage

  return (
    <div>
      {/* TODO スタイル整える 感覚的に変更するのがわかるようにする */}
      <button type="submit" onClick={handleClick}>
        {/* TODO リンク先を変更 ユーザー、ロースターイメージを使用する */}
        <img
          src={isRoaster ? roasterImageUrl : userImageUrl}
          alt=""
          className="object-cover w-20 h-20 rounded-full border-2 border-indigo-500"
        />
      </button>
      <p className="mx-auto text-center font-light">{isRoaster ? 'TO USER' : 'TO ROASTER'}</p>
      <svg className="h-6 w-6 mx-auto text-gray-600 mt-2">
        <use xlinkHref="#switch-horizontal" />
      </svg>
    </div>
  )
}
