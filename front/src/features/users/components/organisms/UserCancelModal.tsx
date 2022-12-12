import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { DangerButton, SecondaryButton } from '@/components/Elements/Button'
import { Modal, ModalContainer, ModalText, ModalTitle } from '@/components/Elements/Modal'
import { useAuth, useSignedInUser } from '@/features/auth'
import { useMessage } from '@/hooks/useMessage'

type Props = {
  isOpen: boolean
  onClose: () => void
}

export const UserCancelModal: FC<Props> = memo((props) => {
  const { isOpen, onClose } = props
  const { deleteUser } = useAuth()
  const { signedInUser } = useSignedInUser()
  const { showMessage } = useMessage()
  const navigate = useNavigate()

  const handleSubmit = async () => {
    if (signedInUser?.guest) {
      showMessage({ message: 'ゲストユーザーの削除はできません', type: 'error' })
      return
    }

    try {
      await deleteUser()
      showMessage({ message: 'アカウントを削除しました', type: 'success' })
      navigate('/')
    } catch {
      showMessage({ message: 'アカウントの削除に失敗しました', type: 'error' })
    }
  }

  return (
    <Modal contentLabel="本当に退会しますか？" isOpen={isOpen} onClose={onClose}>
      <ModalContainer>
        <ModalTitle>アカウントの削除</ModalTitle>
        <div className="sm:mx-12">
          <ModalText>
            <>
              アカウント{`${signedInUser?.name || ''}`}を削除します。
              <br />
              この操作は取り消すことができません。
            </>
          </ModalText>
          <div className="flex items-center justify-center mt-4 space-x-4 sm:space-x-8">
            <SecondaryButton onClick={onClose}>戻る</SecondaryButton>
            <DangerButton onClick={handleSubmit}>了承して削除する</DangerButton>
          </div>
        </div>
      </ModalContainer>
    </Modal>
  )
})
