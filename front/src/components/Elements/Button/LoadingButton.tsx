import type { FC } from 'react'
import { memo } from 'react'

export const LoadingButton: FC = memo(() => (
  <button type="button" className="btn bg-white border-gray-200 text-gray-600 w-16 h-auto">
    <div className="flex justify-center">
      <div className="animate-spin h-4 w-4 border-2 border-gray-400 rounded-full border-t-transparent" />
    </div>
  </button>
))
