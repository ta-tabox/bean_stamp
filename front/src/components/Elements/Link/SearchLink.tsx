import type { FC } from 'react'

export const SearchLink: FC = () => (
  // TODO オファー検索へリンクを貼る
  <div className="py-2 px-4 bg-white text-gray-600 rounded-full border border-gray-200 hover:bg-gray-50 active:bg-gray-200 flex items-center">
    <svg className="w-6 h-6">
      <use xlinkHref="#search" />
    </svg>
    <p className="pl-4 text-xs md:text-sm">オファーを検索</p>
  </div>
)
// <% end %>
