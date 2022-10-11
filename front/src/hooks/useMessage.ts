import { useCallback } from 'react'

import { toast } from 'react-toastify'

import type { TypeOptions } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

type Props = {
  message: string
  type: TypeOptions
}

export const useMessage = () => {
  const showMessage = useCallback(
    (props: Props) => {
      const { message, type } = props
      toast(`${message}`, {
        type: `${type}`,
      })
    },
    [toast]
  )
  return { showMessage }
}
