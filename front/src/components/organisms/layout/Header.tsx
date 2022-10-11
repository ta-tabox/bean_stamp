import type { FC } from 'react'
import { memo } from 'react'
import { useNavigate } from 'react-router-dom'

import { TopButton } from '@/components/atoms/button/TopButton'
import { StaticNavLink } from '@/components/atoms/link/StaticNavLink'
import { useAuth } from '@/hooks/useAuth'
import { useCurrentUser } from '@/hooks/useCurrentUser'

export const Header: FC = memo(() => {
  const { isSignedIn } = useCurrentUser()
  const { signOut } = useAuth()
  const navigate = useNavigate()

  const onClickSingout = () => {
    navigate('/')
    signOut()
  }

  return (
    <section className="h-14 border-t border-b z-50 text-black border-gray-200 bg-gray-100 opacity-80 inset-x-0">
      <div className="h-full flex items-center justify-between">
        <TopButton />
        {/* 切り替えアイコン */}
        <nav className="pr-2 md:pr-12 h-full">
          <ul className="flex h-full">
            <li>
              {isSignedIn ? (
                <StaticNavLink to="/user/home">HOME</StaticNavLink>
              ) : (
                <StaticNavLink to="/">HOME</StaticNavLink>
              )}
            </li>
            {isSignedIn && (
              <li>
                <StaticNavLink to="/user/management">UM</StaticNavLink>
              </li>
            )}
            <li>
              <StaticNavLink to="/about">ABOUT</StaticNavLink>
            </li>
            <li>
              <StaticNavLink to="/help">HELP</StaticNavLink>
            </li>
            {isSignedIn ? (
              <li>
                <button
                  type="button"
                  className="w-20 h-full px-2 flex justify-center items-center text-gray-900 hover:text-white hover:bg-gray-800 e-font"
                  onClick={onClickSingout}
                >
                  SIGNOUT
                </button>
              </li>
            ) : (
              <>
                <li>
                  <StaticNavLink to="/signin">SIGNIN</StaticNavLink>
                </li>
                <li>
                  <StaticNavLink to="/signup">SIGNUP</StaticNavLink>
                </li>
              </>
            )}
          </ul>
        </nav>
      </div>
    </section>
  )
})
