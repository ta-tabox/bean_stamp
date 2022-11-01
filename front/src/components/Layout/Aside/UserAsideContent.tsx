import type { FC } from 'react'
import { memo } from 'react'

import { Copyright } from '@/components/Elements/Copyright/Copyright'
import { SearchLink } from '@/components/Elements/Link/SearchLink'

export const UserAsideContent: FC = memo(() => (
  <div id="user-aside" className="min-h-screen h-auto w-full flex flex-col items-center">
    <div className="w-full sticky top-0 bg-gray-50 z-50">
      <div className="w-44 mt-10 mx-auto">
        <SearchLink />
      </div>
      <section className="h-28 w-full px-6 mt-8 bg-gray-50 flex flex-col justify-start space-y-1 text-center">
        <h1 className="text-md text-gray-600 e-font">Notification</h1>
        {/* TODO 通知を表示する */}
        <div id="user-notification">{/* render 'shared/user_notification' */}通知</div>
      </section>
      <h1 className="w-full pt-4 text-md bg-gray-50 text-gray-600 text-center e-font">Recommendation</h1>
    </div>
    <section className="w-full flex flex-col justify-center items-center space-y-1 pt-4">
      <div id="user-recommendation" className="px-2">
        {/* TODO リコメンデーションを表示、どのようにおすすめしているかわかりやすいように */}
        {/* render partial: 'shared/recommended_offer', collection: @recommended_offers, as: :offer */}
        <div className="h-64 w-32 bg-blue-200 border-b-2 border-white" />
        <div className="h-64 w-32 bg-blue-200 border-b-2 border-white" />
        <div className="h-64 w-32 bg-blue-200 border-b-2 border-white" />
      </div>
    </section>
    <div className="pb-4 mt-auto">
      <Copyright />
    </div>
  </div>
))
