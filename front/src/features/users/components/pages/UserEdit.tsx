import type { FC } from 'react'
import { useState } from 'react'

import { Link } from '@/components/Elements/Link'
import { NotificationMessage } from '@/components/Elements/Notification'
import { Spinner } from '@/components/Elements/Spinner'
import { FormContainer, FormFooter, FormMain, FormTitle } from '@/components/Form'
import { Head } from '@/components/Head'
import { useAuth } from '@/features/auth'
import { UserThumbnail } from '@/features/users/components/molecules/UserThumbnail'
import { UserUpdateForm } from '@/features/users/components/organisms/UserUpdateForm'
import { useNotification } from '@/hooks/useNotification'

export const UserEdit: FC = () => {
  const { user } = useAuth()
  const { notifications } = useNotification()

  const [isError, setIsError] = useState(false)

  return (
    <>
      <Head title="ユーザー編集" />
      {!user && (
        <div className="flex justify-center">
          <Spinner />
        </div>
      )}
      {user && (
        <div className="mt-20">
          <FormContainer>
            <div className="flex justify-end -mb-10">
              <UserThumbnail user={user} />
            </div>
            <FormMain>
              <FormTitle>ユーザー情報編集</FormTitle>
              {isError ? <NotificationMessage notifications={notifications} type="error" /> : null}

              <UserUpdateForm user={user} setIsError={setIsError} />

              {/* プレビューフィールド */}
              <div id="preview" />
              {/* 画像フィールド */}
              <div className="input-container bg-white">
                {/* <%= f.file_field :image, accept:"image/*", class: "input-field", id: 'input-image' %> */}
                <div className="input-icon-field">
                  <i className="fa-solid fa-image fa-lg" />
                </div>
                {/* <%= f.hidden_field :image_cache %> */}
              </div>

              <FormFooter>
                <Link to="/users/cancel">退会する</Link>
                {/* TODO パスワード変更ページの作成 */}
                <Link to="/users/password">パスワード変更</Link>
              </FormFooter>
            </FormMain>
          </FormContainer>
        </div>
      )}
    </>
  )
}
