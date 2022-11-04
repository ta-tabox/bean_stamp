import { atom } from 'recoil'

// ロースター用ページ切り替えに使用
export const isRoasterState = atom<boolean>({
  key: 'isRoasterState',
  default: false,
})
