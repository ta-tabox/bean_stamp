import type { FC } from 'react'
import { memo } from 'react'

import Modal from 'react-modal'

import type { User } from '@/types/api/user'

type Props = {
  user: User | null
  isOpen: boolean
  onClose: () => void
}

Modal.setAppElement('#root')

export const UserDetailModal: FC<Props> = memo((props) => {
  const { isOpen, onClose, user } = props
  return (
    <Modal
      contentLabel="Example Modal"
      isOpen={isOpen}
      className="absolute top-1/2 left-1/2 right-auto bottom-auto -translate-x-1/2 -translate-y-1/2 border-2 border-indigo-400 bg-white text-gray-800 overflow-auto rounded-md outline-none p-6"
      overlayClassName="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-30"
      onRequestClose={onClose}
    >
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
