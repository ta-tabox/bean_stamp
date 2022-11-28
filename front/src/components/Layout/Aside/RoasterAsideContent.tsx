import type { FC } from 'react'
import { memo } from 'react'

import { Copyright } from '@/components/Elements/Copyright'
import { SearchLink } from '@/components/Elements/Link'

export const RoasterAsideContent: FC = memo(() => (
  <div id="roaster-aside" className="min-h-screen flex flex-col items-center">
    <div className="w-44 mt-10">
      <SearchLink target="offer" />
    </div>
    <section className="px-6 mt-8 flex flex-col justify-center space-y-1 text-center">
      <h1 className="text-md text-gray-600 e-font">Notification</h1>
      <ul>
        通知
        {/* TODO オファータスクを表示する */}
        <li>通知はありません</li>
        <li>オファー中のオファーが○件あります</li>
        <li>受け取り期間中のオファーが◯件あります</li>
        {/* <li><%= no_notes_for_roaster(current_user.roaster.offers) %></li>
        <li><%= note_for_on_roasting_offers(current_user.roaster.offers)%></li>
        <li><%= note_for_on_selling_offers(current_user.roaster.offers)%></li> */}
      </ul>
    </section>
    <div className="mt-auto mb-4">
      <Copyright />
    </div>
  </div>
))
