import type { ChangeEvent, FC } from 'react'
import { useEffect, useState, memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { Modal } from '@/components/organisms/layout/Modal'
import type { User } from '@/types/api/user'

type Props = {
  user: User | null
  isOpen: boolean
  isAdmin?: boolean
  onClose: () => void
}

export const UserDetailModal: FC<Props> = memo((props) => {
  const { isOpen, onClose, user, isAdmin = false } = props

  const [name, setName] = useState('')
  const [addressStreet, setAdressStreet] = useState('')
  const [describe, setDescribe] = useState('')

  // 初回レンダリング時とuserの値が変更になった時にモーダルに表示する初期値を設定
  useEffect(() => {
    setName(user?.name ?? '')
    setAdressStreet(user?.address.street ?? '')
    setDescribe(user?.company.name ?? '')
  }, [user])

  const onChangeName = (e: ChangeEvent<HTMLInputElement>) => setName(e.target.value)
  const onChangeAdressStreet = (e: ChangeEvent<HTMLInputElement>) => setAdressStreet(e.target.value)
  const onChangeDescribe = (e: ChangeEvent<HTMLInputElement>) => setDescribe(e.target.value)

  const onClickUpdate = () => alert()

  return (
    <Modal contentLabel={`${user?.name || 'ユーザー'}の詳細`} isOpen={isOpen} onClose={onClose}>
      <div className="form-container">
        <div className="form-main">
          <form>
            <h1 className="form-title">ユーザー詳細</h1>
            <div className="input-container">
              <label htmlFor="user_name">名前</label>
              <input
                type="text"
                name="user[name]"
                value={name}
                id="user_name"
                className="input-field"
                readOnly={!isAdmin}
                onChange={onChangeName}
              />
            </div>
            <div className="input-container">
              <label htmlFor="user_address">住所</label>
              <input
                type="text"
                name="user[address]"
                value={addressStreet}
                id="user_address"
                className="input-field"
                readOnly={!isAdmin}
                onChange={onChangeAdressStreet}
              />
            </div>
            <div className="input-container">
              <label htmlFor="user_describe">詳細</label>
              <input
                type="text"
                name="user[describe]"
                value={describe}
                id="user_describe"
                className="input-field"
                readOnly={!isAdmin}
                onChange={onChangeDescribe}
              />
            </div>
          </form>
        </div>
        {isAdmin && (
          <div className="form-footer">
            <PrimaryButton onClick={onClickUpdate}>更新</PrimaryButton>
          </div>
        )}
      </div>
    </Modal>
  )
})
