import type { FC, ReactNode } from 'react'
import { memo } from 'react'

import { Spinner } from '@/components/Elements/Spinner'

type Props = {
  children: ReactNode
  disabled?: boolean
  loading?: boolean
  onClick?: (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => void
}

export const DangerButton: FC<Props> = memo((props) => {
  const { children, disabled = false, loading = false, onClick } = props
  return (
    <>
      {!loading && (
        <button
          type="submit"
          className="btn bg-rose-500 border-rose-600 text-white hover:bg-rose-600 active:bg-rose-700 bg-"
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
