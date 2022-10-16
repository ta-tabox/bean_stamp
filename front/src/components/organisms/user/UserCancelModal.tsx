import type { FC } from 'react'
import { memo } from 'react'

import { DangerButton } from '@/components/atoms/button/DangerButton'
import { SecondaryButton } from '@/components/atoms/button/SecondaryButton'
import { FormContainer } from '@/components/atoms/form/FormContainer'
import { FormMain } from '@/components/atoms/form/FormMain'
import { FormTitle } from '@/components/atoms/form/FormTitle'
import { Modal } from '@/components/organisms/layout/Modal'
import { useAuth } from '@/hooks/useAuth'
import { useCurrentUser } from '@/hooks/useCurrentUser'

type Props = {
  isOpen: boolean
  onClose: () => void
}

export const UserCancelModal: FC<Props> = memo((props) => {
  const { isOpen, onClose } = props
  const { deleteUser } = useAuth()
  const { currentUser } = useCurrentUser()

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
              {`アカウント${currentUser?.name || ''}`}を削除します。
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
