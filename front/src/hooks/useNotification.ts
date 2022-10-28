import { useRecoilValue, useSetRecoilState } from 'recoil'

import { notificationsState } from '@/stores/notifications'

export const useNotification = () => {
  // Getterを定義
  const notifications = useRecoilValue(notificationsState)

  // Setter, Updaterを定義
  const setNotifications = useSetRecoilState(notificationsState)

  return { notifications, setNotifications }
}
