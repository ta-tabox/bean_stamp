import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { PrimaryButton, SecondaryButton } from '@/components/Elements/Button'
import { Modal } from '@/components/Elements/Modal'
import { FormContainer } from '@/components/Form'

type Props = {
  isOpen: boolean
  onClose: () => void
}

export const RoasterFormCancelModal: FC<Props> = memo((props) => {
  const { isOpen, onClose } = props
  const navigate = useNavigate()

  const handleSubmit = () => {
    navigate(-1)
  }

  return (
    <Modal contentLabel="ロースターフォームデータのリセット" isOpen={isOpen} onClose={onClose}>
      <FormContainer>
        <p className="text-center text-md text-gray-400">
          入力中のデータは削除されます。
          <br />
          キャンセルしますか？
        </p>
        <div className="mx-2 md:mx-12">
          <div className="flex items-center justify-center mt-4 space-x-8">
            <SecondaryButton onClick={onClose}>戻る</SecondaryButton>
            <PrimaryButton onClick={handleSubmit}>OK</PrimaryButton>
          </div>
        </div>
      </FormContainer>
    </Modal>
  )
})
