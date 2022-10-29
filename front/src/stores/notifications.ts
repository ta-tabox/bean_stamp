import { atom } from 'recoil'

export type Notification = {
  id: number
  type: 'info' | 'warning' | 'success' | 'error'
  message: string
}

export type NotificationType = Notification[] | null

export const notificationsState = atom<NotificationType>({
  key: 'notificationsState',
  default: null,
})
