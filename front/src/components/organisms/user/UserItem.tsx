import type { FC } from 'react'
import { memo } from 'react'

type Props = {
  imageUrl: string
  userName: string
  address: string
}

export const UserItem: FC<Props> = memo((props) => {
  const { imageUrl, userName, address } = props
  return (
    <li
      id="roaster-<%= roaster.id %>"
      className="flex flex-col items-center justify-between p-4 duration-300 border-b border-gray-100 sm:border-0 sm:flex-row sm:py-4 px-4 sm:px-8 hover:bg-gray-100"
    >
      <div className="w-full flex items-center text-center flex-col sm:flex-row sm:text-left">
        <div className="mb-2.5 sm:mb-0 sm:mr-4 flex-none">
          <img
            className="object-cover w-20 h-20 border-2 border-indigo-500 rounded-full"
            src={imageUrl}
            alt={`${userName}の画像`}
          />
        </div>
        <div className="w-full flex flex-col mb-4 sm:mb-0 sm:mr-4 overflow-hidden">
          <p className="font-medium truncate">{userName}</p>
          <p className="truncate">{address}</p>
          <p className="truncate text-gray-500">詳細</p>
        </div>
      </div>
    </li>
  )
})
