import type { FC } from 'react'
import { memo } from 'react'
import { Link } from 'react-router-dom'

export const Header: FC = memo(() => (
  <section className="h-14 border-t border-b z-50 text-black border-gray-200 bg-gray-100 opacity-80 inset-x-0">
    <div className="h-full flex items-center justify-between">
      {/* TOPアイコン */}
      <div className="h-full pl-2 md:pl-12 logo-font md:text-xl">
        <Link to="/" className="h-full px-2 flex justify-center items-center text-gray-900">
          Bean Stamp
        </Link>
      </div>
      {/* 切り替えアイコン */}
      <nav className="pr-2 md:pr-12 h-full">
        <ul className="flex h-full">
          <li>
            <Link to="/" className="static-nav-item e-font">
              HOME
            </Link>
          </li>
          <li>
            <Link to="/about" className="static-nav-item e-font">
              ABOUT
            </Link>
          </li>
          <li>
            <Link to="/help" className="static-nav-item e-font">
              HELP
            </Link>
          </li>
        </ul>
      </nav>
    </div>
  </section>
))
