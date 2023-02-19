import { useCallback, useState } from 'react'

export const useModal = () => {
  const [isOpen, setIsOpen] = useState<boolean>(false)

  const onOpen = useCallback(() => {
    setIsOpen(true)
  }, [])

  const onClose = useCallback(() => {
    setIsOpen(false)
  }, [])
  return { isOpen, onOpen, onClose }
}
