import type { FC, ReactNode } from 'react'
import { memo } from 'react'

import { Spinner } from '@/components/Elements/Spinner'

type Props = {
  children: ReactNode
  isButton?: boolean
  disabled?: boolean
  loading?: boolean
  onClick?: () => void
}

export const SecondaryButton: FC<Props> = memo((props) => {
  const { children, isButton = false, disabled = false, loading = false, onClick } = props
  return (
    <>
      {!loading && (
        <button
          type={isButton ? 'button' : 'submit'}
          className="btn btn-pop bg-white border-gray-200 text-gray-600 hover:bg-gray-100 active:bg-gray-200"
          disabled={disabled || loading}
          onClick={onClick}
        >
          {children}
        </button>
      )}

      {loading && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}
    </>
  )
})
