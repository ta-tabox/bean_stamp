import type { FC } from 'react'
import { memo } from 'react'

import { Modal } from '@/components/organisms/layouts/Modal'
import type { User } from '@/types/api/user'

type Props = {
  user: User | null
  isOpen: boolean
  onClose: () => void
}

export const UserDetailModal: FC<Props> = memo((props) => {
  const { isOpen, onClose, user } = props
  return (
    <Modal contentLabel={`${user?.name || 'ユーザー'}の詳細`} isOpen={isOpen} onClose={onClose}>
      <button type="button" onClick={onClose}>
        close
      </button>
      <div className="form-container">
        <div className="form-main">
          <form>
            <h1 className="form-title">ユーザー詳細</h1>
            <div className="input-container">
              <label htmlFor="user_name">名前</label>
              <input type="text" name="user[name]" value={user?.name} id="user_name" className="input-field" readOnly />
            </div>
            <div className="input-container">
              <label htmlFor="user_address">住所</label>
              <input
                type="text"
                name="user[address]"
                value={user?.address.street}
                id="user_address"
                className="input-field"
                readOnly
              />
            </div>
            <div className="input-container">
              <label htmlFor="user_describe">詳細</label>
              <input
                type="text"
                name="user[describe]"
                value={user?.company.name}
                id="user_describe"
                className="input-field"
                readOnly
              />
            </div>
          </form>
        </div>
      </div>
    </Modal>
  )
})
