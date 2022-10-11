import type { FC, ReactNode } from 'react'
import { memo } from 'react'

import { SpinnerLoading } from '@/components/atoms/loading/SpinnerLoading'

type Props = {
  children: ReactNode
  disabled?: boolean
  loading?: boolean
  onClick: () => void
}

export const SecondaryButton: FC<Props> = memo((props) => {
  const { children, disabled = false, loading = false, onClick } = props
  return (
    <>
      {!loading && (
        <button
          type="submit"
          className="btn btn-pop pl-8 pr-2 py-1 lg:pl-2 lg:pt-6 border rounded cursor-pointer block text-center text-sm font-medium;"
          disabled={disabled || loading}
          onClick={onClick}
        >
          {children}
        </button>
      )}

      {loading && (
        <div className="flex justify-center">
          <SpinnerLoading />
        </div>
      )}
    </>
  )
})
