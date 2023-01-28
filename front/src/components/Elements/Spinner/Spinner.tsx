import { memo } from 'react'

export const Spinner = memo(() => (
  // <div className="animate-spin h-6 w-6 border-2 border-gray-400 rounded-full border-t-transparent" />
  <div className="animate-spin">
    <svg className="h-6 w-6 text-gray-500">
      <use xlinkHref="#arrow-path" />
    </svg>
  </div>
))
