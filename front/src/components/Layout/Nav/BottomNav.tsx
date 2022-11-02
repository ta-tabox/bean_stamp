import type { FC } from 'react'
import { memo } from 'react'

import { BottomNavItem } from '@/components/Layout/Nav/BottomNavItem'
import { UserBottomNav } from '@/components/Layout/Nav/UserBottomNav'

export const BottomNav: FC = memo(() => (
  <nav className="h-14 fixed bottom-0 inset-x-0 z-50 border-t border-bray-200 bg-gray-100">
    <div className="h-full px-8 flex items-center justify-between">
      <UserBottomNav />
      {/* TODO ロースターで切り替える */}
      {/* <RoasterBottomNav /> */}
      {/* ハンバーガーメニュー */}
      <div id="hamburger-btn">
        <BottomNavItem>
          <svg id="drawer-open-btn" className="w-8 h-8">
            <use xlinkHref="#menu" />
          </svg>
          <svg id="drawer-close-btn" className="w-8 h-8 hidden">
            <use xlinkHref="#x" />
          </svg>
        </BottomNavItem>
      </div>
      {/* TODO ドロワーメニューの作成 */}
      {/* <div className="drawer-menu relative">
        <div className="absolute bottom-0 inset-x-0">
        <ul className="flex flex-col w-1/2 text-left ml-auto">
          <% unless cookies[:roaster_id] %>
            <li><%= link_to 'マイページ', current_user, className: "drawer-nav-item"%></li>
            <li><%= link_to 'フォロー', following_user_path(current_user), className: "drawer-nav-item"%></li>
          <% else %>
            <li><%= link_to 'マイロースター', roaster_path(current_user.roaster), className: "drawer-nav-item"%></li>
          <% end %>
          <li><%= link_to 'ヘルプ', help_path, className: "drawer-nav-item"%></li>
          <li><%= link_to 'ログアウト', destroy_user_session_path, className: "drawer-nav-item"%></li>
        </ul>
      </div>
      </div> */}
    </div>
  </nav>
))
