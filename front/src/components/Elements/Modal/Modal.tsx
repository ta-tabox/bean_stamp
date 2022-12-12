import type { FC, ReactNode } from 'react'
import { memo } from 'react'

import ReactModal from 'react-modal'

import { SecondaryButton } from '@/components/Elements/Button'

type Props = {
  children: ReactNode
  contentLabel: string
  isOpen: boolean
  onClose: () => void
  closeButton?: boolean
}

ReactModal.setAppElement('#root')

export const Modal: FC<Props> = memo((props) => {
  const { children, contentLabel, isOpen, onClose, closeButton = false } = props
  return (
    <ReactModal
      contentLabel={contentLabel}
      isOpen={isOpen}
      className="min-w-max absolute top-1/2 left-1/2 right-auto bottom-auto -translate-x-1/2 -translate-y-1/2 border-1 border-indigo-400 bg-white text-gray-800 overflow-auto rounded-lg outline-none"
      overlayClassName="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-30"
      onRequestClose={onClose}
    >
      {closeButton && (
        <div className="inline-block relative left-full -translate-x-full">
          <SecondaryButton onClick={onClose}>Close</SecondaryButton>
        </div>
      )}
      {children}
    </ReactModal>
  )
})
