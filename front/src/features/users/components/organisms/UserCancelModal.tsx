import type { FC } from 'react'
import { memo } from 'react'

import { DangerButton, SecondaryButton } from '@/components/Elements/Button'
import { Modal } from '@/components/Elements/Modal'
import { FormContainer, FormMain, FormTitle } from '@/components/Form'
import { useAuth } from '@/features/auth'

type Props = {
  isOpen: boolean
  onClose: () => void
}

export const UserCancelModal: FC<Props> = memo((props) => {
  const { isOpen, onClose } = props
  const { deleteUser } = useAuth()
  const { user } = useAuth()

  const onClickCancel = () => {
    deleteUser()
  }

  return (
    <Modal contentLabel="本当に退会しますか？" isOpen={isOpen} onClose={onClose}>
      <FormContainer>
        <FormMain>
          <FormTitle>アカウントの削除</FormTitle>
          <div className="mx-12">
            <p className="text-center text-xs text-gray-400">
              {`アカウント${user?.name || ''}`}を削除します。
              <br />
              この操作は取り消すことができません。
            </p>
            <div className="flex items-center justify-center mt-4 space-x-8">
              <DangerButton onClick={onClickCancel}>了承して削除する</DangerButton>
              <SecondaryButton onClick={onClose}>戻る</SecondaryButton>
            </div>
          </div>
        </FormMain>
      </FormContainer>
    </Modal>
  )
})
