import type { FC } from 'react'
import { memo } from 'react'

export const RoasterSideNav: FC = memo(() => (
  <ul className="flex flex-col">
    {/* ロースター用 */}
    {/* ロースターホームリンク */}
    <li className="mb-2">
      {/* <%= link_to home_roasters_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#home" />
        </svg>
        <div className="side-nav-text ml-1">Home</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* ロースターページリンク */}
    <li className="mb-2">
      {/* <%= link_to roaster_path(current_user.roaster) do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#coffee-cup" />
        </svg>
        <div className="side-nav-text ml-1">Roaster</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* ビーンズリンク */}
    <li className="mb-2">
      {/* <%= link_to beans_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8 transform -rotate-45">
          <use xlinkHref="#coffee-bean" />
        </svg>
        <div className="side-nav-text ml-1">Beans</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* オファーリンク */}
    <li className="mb-2">
      {/* <%= link_to offers_path do %> */}
      <div className="side-nav-item group flex items-end">
        <svg className="h-8 w-8">
          <use xlinkHref="#clipboard" />
        </svg>
        <div className="side-nav-text ml-1">Offers</div>
      </div>
      {/* <% end %> */}
    </li>
    {/* <% end %> */}
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
