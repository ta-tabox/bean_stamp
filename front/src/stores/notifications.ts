import { atom } from 'recoil'

export type Notification = {
  id: number
  type: 'info' | 'warning' | 'success' | 'error'
  message: string
}

export const notificationsState = atom<Notification[] | null>({
  key: 'notificationsState',
  default: null,
})
