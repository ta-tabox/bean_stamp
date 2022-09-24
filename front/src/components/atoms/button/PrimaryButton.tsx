import type { FC, ReactNode } from 'react'
import { memo } from 'react'

import { SpinnerLoading } from '@/components/atoms/loading/SpinnerLoading'

type Props = {
  children: ReactNode
  disabled?: boolean
  loading?: boolean
  onClick: () => void
}

export const PrimaryButton: FC<Props> = memo((props) => {
  const { children, disabled = false, loading = false, onClick } = props
  return (
    <>
      {!loading && (
        <button
          type="submit"
          className="btn btn-pop bg-indigo-500 border-indigo-600 text-white hover:bg-indigo-600 active:bg-indigo-700"
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
