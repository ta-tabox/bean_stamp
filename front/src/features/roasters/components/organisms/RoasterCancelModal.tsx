import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { DangerButton, SecondaryButton } from '@/components/Elements/Button'
import { Modal, ModalContainer, ModalText, ModalTitle } from '@/components/Elements/Modal'
import { useAuth, useLoadUser } from '@/features/auth'
import { deleteRoaster } from '@/features/roasters/api/deleteRoaster'
import { useCurrentRoaster } from '@/features/roasters/hooks/useCurrentRoaster'
import type { Roaster } from '@/features/roasters/types'
import { useMessage } from '@/hooks/useMessage'

type Props = {
  isOpen: boolean
  onClose: () => void
  roaster: Roaster
}

export const RoasterCancelModal: FC<Props> = memo((props) => {
  const { isOpen, onClose, roaster } = props
  const { authHeaders } = useAuth()
  const { loadUser } = useLoadUser()
  const { setIsRoaster } = useCurrentRoaster()
  const { showMessage } = useMessage()

  const navigate = useNavigate()

  const handleSubmit = async () => {
    if (roaster.guest) {
      showMessage({ message: 'ゲストロースターの削除はできません', type: 'error' })
      navigate('/')
      return
    }

    try {
      await deleteRoaster({ headers: authHeaders, id: roaster.id.toString() })
    } catch {
      showMessage({ message: 'ロースターの削除に失敗しました', type: 'error' })
    }

    await loadUser()

    setIsRoaster(false)
    showMessage({ message: 'ロースターを削除しました', type: 'success' })
    navigate('users/home')
  }

  return (
    <Modal contentLabel="ロースターの削除" isOpen={isOpen} onClose={onClose}>
      <ModalContainer>
        <ModalTitle>ロースターの削除</ModalTitle>
        <div className="sm:mx-12">
          <ModalText>
            <>
              ロースター「{`${roaster.name}`}」を削除します。
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
