import type { FC } from 'react'

type Props = {
  children: string
  backgroundColorClass?: string
  textColorClass?: string
  borderColorClass?: string
}

export const Tag: FC<Props> = (props) => {
  const {
    children,
    backgroundColorClass = 'bg-white',
    textColorClass = 'text-gray-400',
    borderColorClass = 'border-gray-300',
  } = props
  return (
    <div
      className={`border rounded-full text-center px-4 py-2 md:py-1 text-xs md:text-sm font-light tracking-tighter md:tracking-tight capitalize ${backgroundColorClass} ${textColorClass} ${borderColorClass}`}
    >
      {children}
    </div>
  )
}
