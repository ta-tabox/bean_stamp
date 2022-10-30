import type { FC } from 'react'
import { useNavigate } from 'react-router-dom'

import { PrimaryButton } from '@/components/Elements/Button'
import { Head } from '@/components/Head'

export const Page404: FC = () => {
  const navigate = useNavigate()

  const handleClickHome = () => {
    navigate('/')
  }

  return (
    <>
      <Head title="Not Found" />
      <div className="relative flex items-start justify-center min-h-screen bg-gray-100 dark:bg-gray-900 sm:items-center sm:pt-0">
        <div className="max-w-xl mx-auto sm:px-6 lg:px-8 flex flex-col justify-center space-y-4">
          <div className="flex items-center pt-8 sm:justify-start sm:pt-0">
            <div className="px-4 text-lg text-gray-500 border-r border-gray-400 tracking-wider">404 </div>
            <div className="ml-4 text-lg text-gray-500 uppercase tracking-wider">Not Found </div>
          </div>
          <PrimaryButton onClick={handleClickHome}>GO TO HOME</PrimaryButton>
        </div>
      </div>
    </>
  )
}
