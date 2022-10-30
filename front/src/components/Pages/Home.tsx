import type { FC } from 'react'
import { memo } from 'react'
import { Navigate, Link, useNavigate } from 'react-router-dom'

import { PrimaryButton, SecondaryButton } from '@/components/Elements/Button'
import { Head } from '@/components/Head'
import { Header } from '@/components/Layout'
import { useAuth } from '@/features/auth'

export const Home: FC = memo(() => {
  const { isSignedIn } = useAuth()
  const navigate = useNavigate()

  // ルートパスアクセス時にログイン済みならリダイレクト
  if (isSignedIn) {
    return <Navigate to="/user/home" replace />
  }

  const handleClickLogin = () => {
    navigate('/auth/signin')
  }

  const handleClickGuestLogin = () => {
    navigate('/auth/signin')
  }

  return (
    <>
      <Head />
      <div className="top-background relative min-h-screen">
        <Header />
        <main className="container items-center justify-center flex flex-col absolute top-1/2 left-1/2 lg:left-2/3 transform -translate-y-1/3 sm:-translate-y-1/2 -translate-x-1/2">
          <section className="items-center justify-center w-full p-8 flex flex-col">
            <div className="w-11/12 md:w-96 bg-gray-100 items-center justify-center shadow-md p-5 h-auto rounded-lg  bg-opacity-80 flex flex-col col-span-12">
              <hr className="w-48 border-2 border-solid border-indigo-500" />
              <h2 className="mt-8 sm:mt-20 text-yellow-800 text-sm sm:text-lg text-center">
                あなたにとっての一杯のコーヒー
                <br />
                探していきませんか？
              </h2>
              <h1 className="text-gray-800 text-3xl sm:text-5xl text-center mt-2 mb-4 sm:mb-10 font-bold logo-font">
                Bean Stamp
              </h1>
              <Link
                to="/auth/signup"
                className="text-center hover:text-gray-300 bg-yellow-800 text-white hover:bg-black w-40 sm:w-56 p-4 text-2xl font-medium rounded btn-pop"
              >
                登録する
              </Link>
              <div className="py-4 sm:y-8 flex flex-col md:flex-row md:space-x-4 space-y-2 md:space-y-0">
                <PrimaryButton onClick={handleClickLogin}>ログイン</PrimaryButton>
                <SecondaryButton onClick={handleClickGuestLogin}>ゲストログイン</SecondaryButton>
                {/* <%= link_to 'ゲストログイン', users_guest_sign_in_path, method: :post, className: "btn btn-secondary btn-pop" %> */}
              </div>
            </div>
          </section>
        </main>
      </div>
    </>
  )
})
