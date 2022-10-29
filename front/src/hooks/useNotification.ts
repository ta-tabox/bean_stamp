import { useRecoilValue, useSetRecoilState } from 'recoil'

import type { NotificationType } from '@/stores/notifications'
import { notificationsState } from '@/stores/notifications'

type Type = 'info' | 'warning' | 'success' | 'error'

export const useNotification = () => {
  // Getterを定義
  const notifications = useRecoilValue(notificationsState)

  // Setter, Updaterを定義
  const setNotifications = useSetRecoilState(notificationsState)

  // 文字列配列をNotificationTypeに合わせたオブジェクトの配列に変換
  const setNotificationMessagesWithType = (messages: string[], type: Type): NotificationType => {
    const notificationMessages = messages.map((message, index) => ({
      id: index,
      type,
      message: `${message}`,
    }))
    return notificationMessages
  }

  return { notifications, setNotifications, setNotificationMessagesWithType }
}
