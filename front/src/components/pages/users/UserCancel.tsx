import type { FC } from 'react'
import { memo } from 'react'

import { PrimaryButton } from '@/components/atoms/button/PrimaryButton'
import { FormContainer } from '@/components/atoms/form/FormContainer'
import { FormMain } from '@/components/atoms/form/FormMain'
import { FormTitle } from '@/components/atoms/form/FormTitle'
import { UserCancelModal } from '@/components/organisms/user/UserCancelModal'
import { useModal } from '@/hooks/useModal'

export const UserCancel: FC = memo(() => {
  const { isOpen, onOpen, onClose } = useModal()

  const onClickCancel = () => {
    onOpen()
  }

  return (
    // #TODO ページタイトルを動的に変更する
    // <% provide(:title, "アカウントの削除") %>
    <section className="mt-16 flex items-center">
      <FormContainer>
        <FormMain>
          <FormTitle>アカウントを削除しますか？</FormTitle>
          <p className="text-center text-xs text-gray-400">
            アカウントの削除後はユーザー名、コメントは表示されなくなります。
            <br />
            同アカウントによるウォンツやフォローなどのデータは全て失われます。
          </p>
          <div className="flex items-center justify-center mt-4">
            <PrimaryButton onClick={onClickCancel}>退会する</PrimaryButton>
          </div>
        </FormMain>
      </FormContainer>
      <UserCancelModal isOpen={isOpen} onClose={onClose} />
    </section>
  )
})
