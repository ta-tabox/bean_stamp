import type { FC, ReactNode } from 'react'
import { memo } from 'react'

import ReactModal from 'react-modal'

type Props = {
  children: ReactNode
  contentLabel: string
  isOpen: boolean
  onClose: () => void
}

ReactModal.setAppElement('#root')

export const Modal: FC<Props> = memo((props) => {
  const { children, contentLabel, isOpen, onClose } = props
  return (
    <ReactModal
      contentLabel={contentLabel}
      isOpen={isOpen}
      className="absolute top-1/2 left-1/2 right-auto bottom-auto -translate-x-1/2 -translate-y-1/2 border-2 border-indigo-400 bg-white text-gray-800 overflow-auto rounded-md outline-none p-6"
      overlayClassName="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-30"
      onRequestClose={onClose}
    >
      {children}
    </ReactModal>
  )
})
