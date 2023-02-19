import { useNotification } from '@/hooks/useNotification'

export const useErrorNotification = () => {
  const { notifications: errorNotifications, setNotifications, setNotificationMessagesWithType } = useNotification()

  const setErrorNotifications = (messages: string[]): void => {
    const notificationMessages = setNotificationMessagesWithType({ messages, type: 'error' })
    setNotifications(notificationMessages)
  }

  return { errorNotifications, setErrorNotifications }
}
