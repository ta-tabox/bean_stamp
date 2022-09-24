import type { FC } from 'react'
import { memo } from 'react'

export const SignUp: FC = memo(() => (
  // #TODO ページタイトルを動的に変更する
  // <% provide(:title, "サインアップ") %>
  <div className="mt-16 flex items-center">
    <div className="form-container">
      <div className="form-main">
        <h1 className="form-title">サインアップ</h1>
      </div>
    </div>
  </div>
))
