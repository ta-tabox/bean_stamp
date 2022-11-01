import type { FC } from 'react'
import { memo } from 'react'

export const UserSideNav: FC = memo(() => (
  <ul className="flex flex-col">
    {/* ユーザー用 */}
    {/* ユーザーホームリンク */}
    <li className="mb-2">
      {/* <%= link_to home_users_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#home" />
        </svg>
        <div className="side-nav-text ml-1">Home</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* マイページリンク */}
    <li className="mb-2">
      {/* <%= link_to current_user do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#user" />
        </svg>
        <div className="side-nav-text ml-1">User</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* フォローリンク */}
    <li className="mb-2">
      {/* <%= link_to following_user_path(current_user) do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#star" />
        </svg>
        <div className="side-nav-text ml-1">Follow</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* ウォンツリンク */}
    <li className="mb-2">
      {/* <%= link_to wants_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#shopping-bag" />
        </svg>
        <div className="side-nav-text ml-1">Wants</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* お気に入りリンク */}
    <li className="mb-2">
      {/* <%= link_to likes_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#heart" />
        </svg>
        <div className="side-nav-text ml-1">Likes</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* 検索リンク */}
    <li className="mb-2">
      {/* <%= link_to searches_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#search" />
        </svg>
        <div className="side-nav-text ml-1">Search</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* 共通 */}
    {/* ヘルプリンク */}
    <li className="mb-2">
      {/* <%= link_to help_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#question-mark-circle" />
        </svg>
        <div className="side-nav-text ml-1">Help</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* ログアウトリンク */}
    <li className="mb-2">
      {/* <%= link_to destroy_user_session_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#logout" />
        </svg>
        <div className="side-nav-text ml-1">LogOut</div>
      </div>
      {/* <% end %> */}
    </li>
  </ul>
))
